import 'dart:async';
import 'package:database_app/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:database_app/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:database_app/models/note.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = []; // Initialize with an empty list
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList.isEmpty) {
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade400,
        centerTitle: true,
        title: const Text(
          "N O T E",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note("", "", 1, ""), "Add Note");
        },
        tooltip: "Add Note",
        backgroundColor: Colors.amber.shade400, // Customize the color
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 5.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[position].priority),
              child: getPriorityIcon(noteList[position].priority),
            ),
            title: Text(noteList[position].title),
            subtitle: Text(noteList[position].date),
            trailing: GestureDetector(
              child: const Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              navigateToDetail(noteList[position], "Edit Note");
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    if (note.id == null) {
      _showSnackBar(context, "Error: Note ID is null");
      return;
    }

    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, "Note Deleted Successfully");
      updateListView();
    } else {
      _showSnackBar(context, "Error deleting note");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NoteDetail(note, title);
        },
      ),
    );

    if (result) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
