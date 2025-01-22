import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';
import 'create_task.dart';
import '../widgets/info_card.dart';
import 'drawer.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from the database
  void _loadTasks() async {
    List<Task> taskList = await _databaseHelper.getTaskList();
    setState(() {
      tasks = taskList;
    });
  }

  // Delete a task from the database
  void _deleteTask(int index) async {
    await _databaseHelper.deleteTask(tasks[index].id!);
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Navigate to CreateTaskPage to add a new task
  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTaskPage(),
      ),
    ).then((value) {
      if (value != null && value) {
        _loadTasks(); // Reload tasks after saving
      }
    });
  }

  // Navigate to CreateTaskPage to edit an existing task
  void _editTask(Task task, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTaskPage(task: task, taskIndex: index),
      ),
    ).then((value) {
      if (value != null && value) {
        _loadTasks(); // Reload tasks after saving
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      drawer: CustomDrawer(
        // Add the drawer here
        username: 'Sakib Anjum Arnab', // Sample data for username
        email: 'arnab@example.com', // Sample email
        profilePictureUrl:
            'https://www.example.com/profile-picture.jpg', // Sample profile image URL
        isBackupEnabled: false, // Sample value for backup switch
        onBackupToggle: (bool value) {
          // Handle backup toggle functionality here
        },
        onLogout: () {
          // Handle logout functionality here
        },
        onExit: () {
          // Handle exit functionality here
        },
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks available.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: tasks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Opacity(
                    opacity: task.isChecked ? 0.5 : 1.0,
                    child: GestureDetector(
                      onTap: () => _editTask(task, index),
                      child: InfoCard(
                        task: task,
                        onCheckboxChanged: (value) {
                          setState(() {
                            task.isChecked = value ?? false;
                          });
                        },
                        onDelete: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        elevation: 1, // Remove shadow
        //backgroundColor: Colors.transparent, // Transparent background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          side: BorderSide(
            color: Colors.purple.shade300, // Border color
            width: 2, // Border width
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.purple, // Icon color matches the border
        ),
      ),
    );
  }
}
