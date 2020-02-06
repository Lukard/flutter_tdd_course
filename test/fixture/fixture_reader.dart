import 'dart:io';

String fixture(String name) {
  Directory current = Directory.current;
  String separator = Platform.pathSeparator;

  String path = current.path.endsWith('${separator}test')
      ? current.path
      : current.path + '/test';

  return File('$path${separator}fixture$separator$name').readAsStringSync();
}
