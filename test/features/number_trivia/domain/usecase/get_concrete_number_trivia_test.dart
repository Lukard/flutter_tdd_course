import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_concrete_number_trivia_use_case.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock 
  implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTriviaUseCase useCase;
  MockNumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTriviaUseCase(repository);
  });

  final testNumber = 1;
  final testNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository', 
    () async {
      when(repository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(testNumberTrivia));

      final result = await useCase(Params(number: testNumber));

      expect(result, Right(testNumberTrivia));
      verify(repository.getConcreteNumberTrivia(testNumber));
      verifyNoMoreInteractions(repository);
    }
  );
}