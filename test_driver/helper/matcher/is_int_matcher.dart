import 'package:test/test.dart';

class IsInt extends Matcher {
  @override
  Description describe(Description description) => description.add("is Int");

  @override
  bool matches(item, Map matchState) =>
      item is String && int.tryParse(item) != null;
}
