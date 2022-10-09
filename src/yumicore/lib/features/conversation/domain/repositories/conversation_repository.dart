import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/conversation.dart';

abstract class ConversationRepository {
  Future<Either<Failure, Conversation>> getConcreteConversation(String comment);
  Future<Either<Failure, Conversation>> getRandomConversation();
}
