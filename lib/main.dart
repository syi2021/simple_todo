import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:simple_todo/todo_view_model.dart';
import 'package:simple_todo/todo_screen.dart';

final todoProvider = ChangeNotifierProvider((ref) => TodoViewModel());

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Todo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(236, 236, 236, 1),
        primaryColor: const Color(0xff355BAE),
        secondaryHeaderColor: const Color(0xff780E32),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff355BAE)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xff355BAE)),
        textTheme: ThemeData.light().textTheme.copyWith(
            headline4: ThemeData.light()
                .textTheme
                .headline4
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
      home: TodoScreen(),
    );
  }
}
