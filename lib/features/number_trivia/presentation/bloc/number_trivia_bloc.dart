import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:futtler_tdd_course/core/error/failure.dart';
import 'package:futtler_tdd_course/core/usecase/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:futtler_tdd_course/core/util/input_converter.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_concrete_number_trivia_use_case.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/usecase/get_random_number_trivia_use_case.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTriviaUseCase concrete,
      @required GetRandomNumberTriviaUseCase random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTriviaUseCase = concrete,
        getRandomNumberTriviaUseCase = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield Error(INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreteNumberTriviaUseCase(Params(number: integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTriviaUseCase(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
        (failure) => Error(_mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
