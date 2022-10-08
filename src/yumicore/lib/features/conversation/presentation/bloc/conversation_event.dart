part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent(String conversationString);

  @override
  List<Object> get props => [];
}

class GetConversationForConcreteStringEvent extends ConversationEvent {
  final String conversationString;

  const GetConversationForConcreteStringEvent(this.conversationString)
      : super(conversationString);
}

//class GetConversationForRandomString extends ConversationEvent {}
