import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumicore/features/conversation/data/models/conversation_model.dart';

import '../../../../core/error/exceptions.dart';

abstract class ConversationLocalDataSource {
  /// Gets the cached [ConversationModel] which was gotten the last time
  /// user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ConversationModel> getLastConversation();
  Future<void> cacheConversation(ConversationModel conversationCache);
}

const CACHE_CONVERSATION = 'CACHED_CONVERSATION';

class ConversationLocalDataSourceImpl implements ConversationLocalDataSource {
  SharedPreferences sharePreferences;
  ConversationLocalDataSourceImpl({required this.sharePreferences});

  @override
  Future<ConversationModel> getLastConversation() {
    final jsonString = sharePreferences.getString(CACHE_CONVERSATION);
    if (jsonString != null) {
      return Future.value(ConversationModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheConversation(ConversationModel conversationToCache) {
    return sharePreferences.setString(
        CACHE_CONVERSATION, json.encode(conversationToCache));
  }
}
