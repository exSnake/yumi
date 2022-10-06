import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:yumicore/core/error/exceptions.dart';
import 'package:yumicore/core/error/failures.dart';
import 'package:yumicore/features/conversation/data/datasources/conversation_local_data_source.dart';
import 'package:yumicore/features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumicore/core/platform/network_info.dart';
import 'package:yumicore/features/conversation/data/models/conversation_model.dart';
import 'package:yumicore/features/conversation/data/repositories/conversation_repository_impl.dart';

class MockRemoteDataSource extends Mock
    implements ConversationRemoteDataSource {}

class MockLocalDataSource extends Mock implements ConversationLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ConversationRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ConversationRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteConversation', () {
    final tNumber = 1;
    final tConversationModel =
        ConversationModel(number: tNumber, text: 'Test Text');
    final ConversationModel tConversation = tConversationModel;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteConversation(any()))
            .thenAnswer((_) async => tConversationModel);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.cacheConversation(tConversationModel))
            .thenAnswer((_) async => Future.value());
        // act
        repository.getConcreteConversation(tNumber);
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should return remote data when the call to remote data source is succes',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteConversation(any()))
              .thenAnswer((_) async => tConversationModel);
          when(() => mockLocalDataSource.cacheConversation(tConversationModel))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.getConcreteConversation(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteConversation(tNumber));
          expect(result, equals(Right(tConversation)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is succes',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteConversation(any()))
              .thenAnswer((_) async => tConversationModel);
          when(() => mockLocalDataSource.cacheConversation(tConversationModel))
              .thenAnswer((_) async => Future.value());
          // act
          await repository.getConcreteConversation(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteConversation(tNumber));
          verify(
              () => mockLocalDataSource.cacheConversation(tConversationModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getConcreteConversation(any()))
              .thenThrow(ServerException());
          when(() => mockLocalDataSource.cacheConversation(tConversationModel))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.getConcreteConversation(tNumber);
          // assert
          verify(() => mockRemoteDataSource.getConcreteConversation(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastConversation())
              .thenAnswer((_) async => tConversationModel);
          // act
          final result = await repository.getConcreteConversation(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastConversation());
          expect(result, equals(Right(tConversation)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastConversation())
              .thenThrow(CacheException());
          // act
          final result = await repository.getConcreteConversation(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastConversation());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomConversation', () {
    final tConversationModel =
        ConversationModel(number: 123, text: 'Test Text');
    final ConversationModel tConversation = tConversationModel;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomConversation())
            .thenAnswer((_) async => tConversationModel);
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.cacheConversation(tConversationModel))
            .thenAnswer((_) async => Future.value());
        // act
        repository.getRandomConversation();
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should return remote data when the call to remote data source is succes',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomConversation())
              .thenAnswer((_) async => tConversationModel);
          when(() => mockLocalDataSource.cacheConversation(tConversationModel))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.getRandomConversation();
          // assert
          verify(() => mockRemoteDataSource.getRandomConversation());
          expect(result, equals(Right(tConversation)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is succes',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomConversation())
              .thenAnswer((_) async => tConversationModel);
          when(() => mockLocalDataSource.cacheConversation(tConversationModel))
              .thenAnswer((_) async => Future.value());
          // act
          await repository.getRandomConversation();
          // assert
          verify(() => mockRemoteDataSource.getRandomConversation());
          verify(
              () => mockLocalDataSource.cacheConversation(tConversationModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getRandomConversation())
              .thenThrow(ServerException());
          when(() => mockLocalDataSource.cacheConversation(tConversationModel))
              .thenAnswer((_) async => Future.value());
          // act
          final result = await repository.getRandomConversation();
          // assert
          verify(() => mockRemoteDataSource.getRandomConversation());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastConversation())
              .thenAnswer((_) async => tConversationModel);
          // act
          final result = await repository.getRandomConversation();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastConversation());
          expect(result, equals(Right(tConversation)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data',
        () async {
          // arrange
          when(() => mockLocalDataSource.getLastConversation())
              .thenThrow(CacheException());
          // act
          final result = await repository.getRandomConversation();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastConversation());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
