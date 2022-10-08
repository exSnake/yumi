import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yumicore/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/usecases/get_concrete_conversation.dart';
import '../../domain/usecases/get_random_conversation.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

const INVALID_INPUT_FAILURE_MESSAGE = 'Invalid input';
const SERVER_FAILURE_MESSAGE = 'Server Error';
const CACHE_FAILURE_MESSAGE = 'Cache error';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetConcreteConversation getConcreteConversation;
  final GetRandomConversation getRandomConversation;
  final InputConverter inputConverter;
  ConversationBloc(
      {required this.getConcreteConversation,
      required this.getRandomConversation,
      required this.inputConverter})
      : super(Empty()) {
    on<GetConversationForConcreteStringEvent>(
        (event, emit) => _onConcreteStringEvent(event, emit));
    on<GetConversationForRandomStringEvent>(
        (event, emit) => _onRandomStringEvent(event, emit));
  }

  _onConcreteStringEvent(GetConversationForConcreteStringEvent event,
      Emitter<ConversationState> emit) {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.conversationString);
    inputEither.fold((failure) => _emitError(failure, emit),
        (integer) => _workOnInteger(integer, emit));
  }

  _emitError(Failure failure, Emitter<ConversationState> emit) {
    emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
  }

  _workOnInteger(int integer, Emitter<ConversationState> emit) async {
    emit(Loading());
    final failureOrConversation =
        await getConcreteConversation(Params(number: integer));
    _eitherLoadedOrErrorState(failureOrConversation, emit);
  }

  void _eitherLoadedOrErrorState(
      Either<Failure, Conversation> failureOrConversation,
      Emitter<ConversationState> emit) {
    failureOrConversation.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))),
        (conversation) => emit(Loaded(conversation: conversation)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  _onRandomStringEvent(GetConversationForRandomStringEvent event,
      Emitter<ConversationState> emit) async {
    emit(Loading());
    final failureOrConversation = await getRandomConversation(NoParams());
    _eitherLoadedOrErrorState(failureOrConversation, emit);
  }
}
