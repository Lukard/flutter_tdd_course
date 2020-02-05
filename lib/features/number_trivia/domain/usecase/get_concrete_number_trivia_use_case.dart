import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futtler_tdd_course/core/usecase/usecase.dart';
import 'package:meta/meta.dart';
import 'package:futtler_tdd_course/core/error/failure.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/repository/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];

}
