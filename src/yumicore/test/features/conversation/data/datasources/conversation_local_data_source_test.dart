import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumicore/core/error/exceptions.dart';
import 'package:yumicore/features/conversation/data/datasources/conversation_local_data_source.dart';
import 'package:yumicore/features/conversation/data/models/conversation_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ConversationLocalDataSourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() async {
    mockSharedPreferences = MockSharedPreferences();
    datasource = ConversationLocalDataSourceImpl(
        sharePreferences: mockSharedPreferences);
  });

  group('getLastConversation', () {
    final tConversationModel = ConversationModel.fromJson(
        json.decode(fixture('conversation_cached.json')));
    test(
      'should return conversation from shared preferences when there is one in the cache',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any()))
            .thenReturn(fixture('conversation_cached.json'));
        // act
        final result = await datasource.getLastConversation();
        // assert
        verify(() => mockSharedPreferences.getString(CACHE_CONVERSATION));
        expect(result, equals(tConversationModel));
      },
    );

    test(
      'should throw a cache exceptions when there is no cached value',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        // act
        final call = datasource.getLastConversation;
        // assert
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheConversation', () {
    const tConversationModel = ConversationModel(number: 1, text: 'Test Text');
    test(
      'should call SharedPreferences to cache the data',
      () async {
        //arrange
        when(() => mockSharedPreferences.setString(
                CACHE_CONVERSATION, json.encode(tConversationModel)))
            .thenAnswer((_) async => true);
        // act
        datasource.cacheConversation(tConversationModel);
        // assert
        final expectedJsonString = json.encode(tConversationModel.toJson());
        verify(() => mockSharedPreferences.setString(
            CACHE_CONVERSATION, expectedJsonString));
      },
    );
  });
}
