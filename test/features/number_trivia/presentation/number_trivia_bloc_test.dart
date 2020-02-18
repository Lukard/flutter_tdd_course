import 'package:futtler_tdd_course/core/error/failure.dart';
import 'package:futtler_tdd_course/core/usecase/usecase.dart';
import 'package:futtler_tdd_course/core/util/input_converter.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_concrete_number_trivia_use_case.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_random_number_trivia_use_case.dart';
import 'package:futtler_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

class MockGetConcreteNumberTriviaUseCase extends Mock
    implements GetConcreteNumberTriviaUseCase {}

class MockGetRandomNumberTriviaUseCase extends Mock
    implements GetRandomNumberTriviaUseCase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  MockGetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  MockInputConverter inputConverter;

  setUp(() {
    getConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    getRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    inputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: getConcreteNumberTriviaUseCase,
        random: getRandomNumberTriviaUseCase,
        inputConverter: inputConverter);
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final testNumberString = '1';
    final testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(testNumberParsed));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(testNumberParsed));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));

      verify(inputConverter.stringToUnsignedInteger(testNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(inputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [Empty(), Error(INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTriviaUseCase(any))
          .thenAnswer((_) async => Right(testNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(getConcreteNumberTriviaUseCase(any));

      verify(getConcreteNumberTriviaUseCase(Params(number: testNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten susuccessfully',
        () async {
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTriviaUseCase(any))
          .thenAnswer((_) async => Right(testNumberTrivia));

      final expected = [
        Empty(),
        Loading(),
        Loaded(testNumberTrivia),
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTriviaUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTriviaUseCase(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(testNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final testNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the concrete use case', () async {
      when(getRandomNumberTriviaUseCase(any))
          .thenAnswer((_) async => Right(testNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(getRandomNumberTriviaUseCase(any));

      verify(getRandomNumberTriviaUseCase(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten susuccessfully',
        () async {
      when(getRandomNumberTriviaUseCase(any))
          .thenAnswer((_) async => Right(testNumberTrivia));

      final expected = [
        Empty(),
        Loading(),
        Loaded(testNumberTrivia),
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(getRandomNumberTriviaUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      when(getRandomNumberTriviaUseCase(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
