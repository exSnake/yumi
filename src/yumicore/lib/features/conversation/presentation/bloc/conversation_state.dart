part of 'conversation_bloc.dart';

abstract class ConversationState extends Equatable {
  const ConversationState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Empty extends ConversationState {}

class Loading extends ConversationState {}

class Loaded extends ConversationState {
  final Conversation conversation;

  Loaded({required this.conversation}) : super([conversation]);
}

class Error extends ConversationState {
  final String message;

  Error({required this.message}) : super([message]);
}
