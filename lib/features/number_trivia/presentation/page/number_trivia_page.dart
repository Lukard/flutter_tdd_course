import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futtler_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:futtler_tdd_course/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:futtler_tdd_course/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return MessageDisplay(message: 'Start Searching!');
                } else if (state is Loading) {
                  return LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else if (state is Error) {
                  return MessageDisplay(message: state.message);
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TriviaControls(),
          ],
        ),
      ),
    );
  }
}
