import 'package:database_app/firebase_options.dart';
import 'package:database_app/screens/login_create_account_screen.dart';
import 'package:database_app/screens/task_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
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
     home: FirebaseAuth.instance.currentUser != null ? const TaskManager() : const LoginCreateAccountScreen(),
    );
  }
}
