import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yumicore/features/conversation/domain/repositories/conversation_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/conversation.dart';

class GetConcreteConversation implements UseCase<Conversation, Params> {
  final ConversationRepository repository;

  GetConcreteConversation(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(Params params) async {
    return await repository.getConcreteConversation(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object> get props => [number];
}
