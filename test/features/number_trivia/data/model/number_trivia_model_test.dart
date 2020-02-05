import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:futtler_tdd_course/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:futtler_tdd_course/features/number_trivia/domain/entity/number_trivia.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of NumberTrivia entity', () {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_int.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, testNumberTriviaModel);
    });

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));

        final result = NumberTriviaModel.fromJson(jsonMap);

        expect(result, testNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = testNumberTriviaModel.toJson();

      final expectedJsonMap = {
        "text": "Test Text",
        "number": 1
      };

      expect(result, expectedJsonMap);
    });
  });
}
