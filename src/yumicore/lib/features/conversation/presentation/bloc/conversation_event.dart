part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class GetConversationForConcrete extends ConversationEvent {
  final String conversationString;

  const GetConversationForConcrete(this.conversationString);
}
