import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:futtler_tdd_course/core/network/network_info.dart';
import 'package:futtler_tdd_course/core/util/input_converter.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_concrete_number_trivia_use_case.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_random_number_trivia_use_case.dart';
import 'package:futtler_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  initFeatures();
  initCore();
  await initExternal();
}

void initFeatures() {
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      concrete: serviceLocator(),
      inputConverter: serviceLocator(),
      random: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTriviaUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTriviaUseCase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );
}

void initCore() {
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );
}

Future<void> initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
