import 'package:database_app/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:database_app/models/note.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<NoteDetail> createState() => _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;

  _NoteDetailState(this.note, this.appBarTitle);

  static var _priorities = ["High", "Low"];

  DatabaseHelper helper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade400,
        title: Text(appBarTitle, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser!);
                    });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: TextField(
                controller: titleController,
                onChanged: (value) {
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: TextField(
                controller: descriptionController,
                onChanged: (value) {
                  updateDescription();
                },
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Save"),
                      onPressed: () {
                        setState(() {
                          _save();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Delete"),
                      onPressed: () {
                        setState(() {
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    switch (value) {
      case 1:
        return _priorities[0]; // High
      case 2:
        return _priorities[1]; // Low
      default:
        return "Unknown"; // Fallback for unexpected values
    }
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    _moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note); // Update operation
    } else {
      result = await helper.insertNote(note); // Insert operation
    }

    if (result != 0) {
      _showAlterDialog("Status", "Note Saved Successfully");
    } else {
      _showAlterDialog("Status", "Problem Saving Note");
    }
  }

  void _showAlterDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    _moveToLastScreen();

    if (note.id == null) {
      _showAlterDialog("Status", "No Note was selected for deletion");
      return;
    }

    int result = await helper.deleteNote(note.id!); // Use the non-null assertion operator
    if (result != 0) {
      _showAlterDialog("Status", "Note Deleted Successfully");
    } else {
      _showAlterDialog("Status", "Error Occurred while Deleting Note.");
    }
  }

  void _moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
