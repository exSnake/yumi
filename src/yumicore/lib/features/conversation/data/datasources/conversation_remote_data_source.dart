import 'dart:convert';

import 'package:yumicore/features/conversation/data/models/conversation_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

abstract class ConversationRemoteDataSource {
  /// Calls the api endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<ConversationModel> getConcreteConversation(String comment);

  /// Calls the api endpoint to get a random Conversation
  ///
  /// Throws a [ServerException] for all error codes
  Future<ConversationModel> getRandomConversation();
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDataSource {
  final http.Client client;
  final url = 'http://localhost:5001/';
  final headers = {'Content-Type': 'application/json'};

  ConversationRemoteDataSourceImpl({required this.client});

  Future<ConversationModel> _getConversationFromUrl(String url) async {
    final response = await client.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return ConversationModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ConversationModel> getConcreteConversation(String comment) =>
      _getConversationFromUrl('http://localhost:5001/query=?$comment');

  @override
  Future<ConversationModel> getRandomConversation() =>
      _getConversationFromUrl('http://localhost:5001/random');
}
