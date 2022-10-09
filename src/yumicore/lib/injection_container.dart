import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yumicore/features/conversation/presentation/bloc/conversation_bloc.dart';

import 'package:http/http.dart' as http;
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/conversation/data/datasources/conversation_local_data_source.dart';
import 'features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'features/conversation/data/repositories/conversation_repository_impl.dart';
import 'features/conversation/domain/repositories/conversation_repository.dart';
import 'features/conversation/domain/usecases/get_concrete_conversation.dart';
import 'features/conversation/domain/usecases/get_random_conversation.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Conversation

  //Bloc
  sl.registerFactory(() =>
      ConversationBloc(concrete: sl(), random: sl(), inputConverter: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetConcreteConversation(sl()));
  sl.registerLazySingleton(() => GetRandomConversation(sl()));

  // Repository
  sl.registerLazySingleton<ConversationRepository>(() =>
      ConversationRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  //Data sources
  sl.registerLazySingleton<ConversationRemoteDataSource>(
      () => ConversationRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ConversationLocalDataSource>(
      () => ConversationLocalDataSourceImpl(sharePreferences: sl()));

  // Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
