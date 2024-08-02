import 'package:flutter/material.dart';
import '../../presentation/screens/airplane_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repository/airplane_repository.dart';
import 'presentation/cubit/airplane_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AirplaneCubit>(
          create: (context) => AirplaneCubit(AirplaneRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Airplane App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AirplaneListScreen(),
      ),
    );
  }
}
