import '../../domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({required comment, required code})
      : super(comment: comment, code: code);
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(comment: json['comment'], code: json['code']);
  }

  Map<String, dynamic> toJson() {
    return {'comment': comment, 'code': code};
  }
}
