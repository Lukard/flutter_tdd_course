import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/core/platform/network_info.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo
    );
  });
}
