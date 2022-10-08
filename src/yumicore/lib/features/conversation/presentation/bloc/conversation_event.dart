part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConversationForConcreteStringEvent extends ConversationEvent {
  final String conversationString;

  GetConversationForConcreteStringEvent(this.conversationString);

  @override
  List<Object> get props => [conversationString];
}

class GetConversationForRandomStringEvent extends ConversationEvent {}
