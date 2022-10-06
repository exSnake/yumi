import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/conversation.dart';

abstract class ConversationRepository {
  Future<Either<Failure, Conversation>> getConcreteConversation(int number);
  Future<Either<Failure, Conversation>> getRandomConversation();
}
