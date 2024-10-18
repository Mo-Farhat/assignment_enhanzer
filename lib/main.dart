import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/task_view_model.dart';
import 'views/task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TasksScreen(),
      ),
    );
  }
}