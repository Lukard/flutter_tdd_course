import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/core/error/exception.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixture/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSource dataSource;
  MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    dataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(sharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(sharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(testNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      when(sharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () async {
      dataSource.cacheNumberTrivia(testNumberTriviaModel);

      final expectedJsonString = json.encode(testNumberTriviaModel);
      verify(sharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
