import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../datasources/conversation_local_data_source.dart';
import '../datasources/conversation_remote_data_source.dart';
import '../models/conversation_model.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;
  final ConversationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ConversationRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Conversation>> getConcreteConversation(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteConversation(number);
    });
  }

  @override
  Future<Either<Failure, Conversation>> getRandomConversation() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomConversation();
    });
  }

  Future<Either<Failure, Conversation>> _getTrivia(
      Future<ConversationModel> Function() getContreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteConversation = await getContreteOrRandom();
        localDataSource.cacheConversation(remoteConversation);
        return Right(remoteConversation);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastConversation();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
