import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/conversation_repository.dart';

class GetRandomConversation implements UseCase<Conversation, NoParams> {
  final ConversationRepository repository;

  GetRandomConversation(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(NoParams params) async {
    return await repository.getRandomConversation();
  }
}
