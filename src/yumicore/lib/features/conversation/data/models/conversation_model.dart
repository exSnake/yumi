import '../../domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({required text, required number})
      : super(text: text, number: number);
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(text: json['text'], number: json['number']);
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'number': number};
  }
}
