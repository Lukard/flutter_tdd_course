import 'dart:io';

String fixture(String name) {
  Directory current = Directory.current;
  String path =
      current.path.endsWith('/test') ? current.path : current.path + '/test';

  return File('$path/fixture/$name').readAsStringSync();
}
