import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumicore/core/error/exceptions.dart';
import 'package:yumicore/features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'package:yumicore/features/conversation/data/models/conversation_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ConversationRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() async {
    mockHttpClient = MockHttpClient();
    dataSource = ConversationRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
            (_) async => http.Response(fixture('conversation.json'), 200));
  }

  void setUpMockHttpClientSuccess404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteConversation', () {
    const tComment = '1';
    final tConversationModel =
        ConversationModel.fromJson(json.decode(fixture('conversation.json')));
    registerFallbackValue(Uri.parse(''));

    test(
      '''should perfmor a GET request on a URL with number 
      being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteConversation(tComment);
        // assert
        verify(() => mockHttpClient.get(
            Uri.parse('http://localhost:5001/query=$tComment'),
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return conversation when response is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteConversation(tComment);
        // assert
        expect(result, equals(tConversationModel));
      },
    );

    test(
      'should throw a ServeRException when response is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientSuccess404();
        // act
        final call = dataSource.getConcreteConversation;
        // assert
        expect(() => call(tComment), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomConversation', () {
    final tConversationModel =
        ConversationModel.fromJson(json.decode(fixture('conversation.json')));
    registerFallbackValue(Uri.parse(''));

    test(
      '''should perfmor a GET request on a URL with number 
      being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomConversation();
        // assert
        verify(() => mockHttpClient.get(
            Uri.parse('http://localhost:5001/random'),
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return conversation when response is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomConversation();
        // assert
        expect(result, equals(tConversationModel));
      },
    );

    test(
      'should throw a ServeRException when response is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientSuccess404();
        // act
        final call = dataSource.getRandomConversation;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
