import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/core/error/exception.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixture/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: httpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
         being the endpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(testNumber);

      verify(httpClient.get('http://numbersapi.com/$testNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response is 200 (success)',
        () async {
          setUpMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(testNumber);

      expect(result, equals(testNumberTriviaModel));
    });
    
    test('should throw a ServerException when the response code is other than 200', () {
      setUpMockHttpClientFailure404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(testNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
         being the endpoint and with application/json header''', () async {
      setUpMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(httpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response is 200 (success)',
            () async {
          setUpMockHttpClientSuccess200();

          final result = await dataSource.getRandomNumberTrivia();

          expect(result, equals(testNumberTriviaModel));
        });

    test('should throw a ServerException when the response code is other than 200', () {
      setUpMockHttpClientFailure404();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
