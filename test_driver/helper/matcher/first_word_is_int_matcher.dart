import 'package:test/test.dart';

class FirstWordIsInt extends Matcher {
  @override
  Description describe(Description description) =>
      description.add("starts with Int");

  @override
  bool matches(item, Map matchState) =>
      item is String &&
      int.tryParse(item.substring(0, item.indexOf(" "))) != null;
}
