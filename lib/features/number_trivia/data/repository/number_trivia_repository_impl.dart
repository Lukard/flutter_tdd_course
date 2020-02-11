import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:futtler_tdd_course/core/error/failure.dart';
import 'package:futtler_tdd_course/core/platform/network_info.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/repository/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
