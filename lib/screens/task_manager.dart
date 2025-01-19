import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';
import 'create_task.dart';
import '../widgets/info_card.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({Key? key}) : super(key: key);

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
      body: tasks.isEmpty
          ? const Center(
              child: Text('No tasks available.'),
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
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          onPressed: _addNewTask,
          backgroundColor: Colors.blue.shade300,
          elevation: 8,
          child: const Icon(
            Icons.task,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}