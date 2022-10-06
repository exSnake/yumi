import 'package:yumicore/features/conversation/data/models/conversation_model.dart';

abstract class ConversationLocalDataSource {
  /// Gets the cached [ConversationModel] which was gotten the last time
  /// user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ConversationModel> getLastConversation();
  Future<void> cacheConversation(ConversationModel conversationCache);
}
