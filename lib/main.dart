import 'package:database_app/screens/note_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DBApp());
}

class DBApp extends StatelessWidget {
  const DBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "NoteKeeper",
      debugShowCheckedModeBanner: false,
      home: NoteList(),
    );
  }
}