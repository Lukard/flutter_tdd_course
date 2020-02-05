import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:futtler_tdd_course/core/error/failure.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/repository/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase {
  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({
    @required int number
  }) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
