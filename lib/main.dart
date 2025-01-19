import 'package:database_app/screens/task_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DBApp());
}

class DBApp extends StatelessWidget {
  const DBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskManager(),
    );
  }
}
