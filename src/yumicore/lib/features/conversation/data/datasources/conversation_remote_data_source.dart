import 'package:yumicore/features/conversation/data/models/conversation_model.dart';

abstract class ConversationRemoteDataSource {
  /// Calls the api endpoint.
  ///
  /// Throws a [ServerException] for all error codes
  Future<ConversationModel> getConcreteConversation(int number);

  /// Calls the api endpoint to get a random Conversation
  ///
  /// Throws a [ServerException] for all error codes
  Future<ConversationModel> getRandomConversation();
}
