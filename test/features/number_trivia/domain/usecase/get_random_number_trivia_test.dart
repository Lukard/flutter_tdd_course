import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/core/usecase/usecase.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_random_number_trivia_use_case.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
  implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTriviaUseCase useCase;
  MockNumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTriviaUseCase(repository);
  });

  final testNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test(
    'should get trivia from repository', 
    () async {
      when(repository.getRandomNumberTrivia())
      .thenAnswer((_) async => Right(testNumberTrivia));

      final result = await useCase(NoParams());

      expect(result, Right(testNumberTrivia));
      verify(repository.getRandomNumberTrivia());
      verifyNoMoreInteractions(repository);
    }
  );
}