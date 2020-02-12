import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/core/error/exception.dart';
import 'package:futtler_tdd_course/core/error/failure.dart';
import 'package:futtler_tdd_course/core/network/network_info.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
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
      networkInfo: networkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel(number: testNumber, text: 'test trivia');
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test('should check if the device is online', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      repository.getConcreteNumberTrivia(testNumber);

      verify(networkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
        expect(result, equals(Right(testNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => testNumberTriviaModel);

        await repository.getConcreteNumberTrivia(testNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
        verify(localDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verify(remoteDataSource.getConcreteNumberTrivia(testNumber));
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test(
          'should return CacheFailure data when there is no cached data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(testNumber);

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test('should check if the device is online', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      repository.getRandomNumberTrivia();

      verify(networkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => testNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Right(testNumberTrivia)));
      });

      test(
          'should return CacheFailure data when there is no cached data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
