import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'helper/matcher/first_word_is_int_matcher.dart';
import 'helper/matcher/is_int_matcher.dart';

void main() {
  group('Number Trivia App', () {
    SerializableFinder display;
    SerializableFinder numberDisplay;
    SerializableFinder descriptionDisplay;
    SerializableFinder input;
    SerializableFinder concreteButton;
    SerializableFinder randomButton;

    FlutterDriver driver;

    setUp(() async {
      driver = await FlutterDriver.connect();
      driver.requestData("holi");
      display = find.byValueKey('Display');
      numberDisplay = find.byValueKey('Number Display');
      descriptionDisplay = find.byValueKey('Description Display');
      input = find.byValueKey('Input');
      concreteButton = find.byValueKey('Concrete');
      randomButton = find.byValueKey('Random');
    });

    tearDown(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test(
        'given input number when user clicks on search then the input number trivia is displayed',
        () async {
      expect(await driver.getText(display), 'Start Searching!');
      expect(await driver.getText(input), '');

      await driver.tap(input);
      await driver.enterText('1');
      await driver.tap(concreteButton);

      expect(await driver.getText(numberDisplay), '1');
      expect(await driver.getText(descriptionDisplay), startsWith('1'));
    });

    test(
        'given no input number when user clicks on search then nothing should happen',
        () async {
      expect(await driver.getText(display), 'Start Searching!');
      expect(await driver.getText(input), '');

      await driver.tap(concreteButton);

      expect(await driver.getText(display), 'Start Searching!');
      expect(await driver.getText(input), '');
    });

    test(
        'when user clicks on get random trivia button then a random number trivia is displayed',
        () async {
      expect(await driver.getText(display), 'Start Searching!');
      expect(await driver.getText(input), '');

      await driver.tap(randomButton);

      expect(await driver.getText(numberDisplay), new IsInt());
      expect(await driver.getText(descriptionDisplay), new FirstWordIsInt());
    });
  });
}
