import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yumicore/features/conversation/data/models/conversation_model.dart';
import 'package:yumicore/features/conversation/domain/entities/conversation.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tConversationModel = ConversationModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of ConversationModel entity',
    () async {
      // arrange

      // act

      // assert
      expect(tConversationModel, isA<Conversation>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model wheen the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('conversation.json'));
        // act
        final result = ConversationModel.fromJson(jsonMap);
        // assert
        expect(result, tConversationModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return JSON map containing the proper data',
      () async {
        // arrange
        final result = tConversationModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
