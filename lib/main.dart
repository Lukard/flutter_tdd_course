import 'dart:async';

import 'package:flutter/material.dart';
import 'package:futtler_tdd_course/features/number_trivia/presentation/page/number_trivia_page.dart';
import 'file:///C:/Development/futtler_tdd_course/test_driver/helper/widget/restart_for_testing.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

void test(StreamController<int> streamController) async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(RestartWidget(
    child: MyApp(),
    streamController: streamController,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: NumberTriviaPage(),
    );
  }
}
