import 'package:database_app/screens/login_screen.dart';
import 'package:database_app/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<Task> filteredTasks = []; // List to hold filtered tasks
  bool isSearching = false; // Flag to check if search is active
  TextEditingController searchController = TextEditingController(); // Controller for search bar

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
      filteredTasks = taskList; // Initially show all tasks
    });
  }

  // Update tasks based on search query
  void _searchTasks(String query) {
    final filtered = tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredTasks = filtered;
    });
  }

  // Delete a task from the database
  void _deleteTask(int index) async {
    await _databaseHelper.deleteTask(tasks[index].id!);
    setState(() {
      tasks.removeAt(index);
      filteredTasks = tasks; // Reset filtered list after deletion
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

  // Handle user logout
  Future<void> _logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      // Navigate to the login/create account screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginCreateAccountScreen()),
        (route) => false,
      );
    } catch (e) {
      // Show error if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void _navigateToLoginCreateAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginCreateAccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search by title...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: _searchTasks,
              )
            : const Text('Task Manager'),
        actions: [
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchController.clear();
                      filteredTasks = tasks; // Reset to all tasks when search is canceled
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const SizedBox(width: 15); // Empty space instead of button
              } else {
                return CustomOutlinedButton(
                  onPressed: () => _navigateToLoginCreateAccountScreen(context),
                  text: 'Login',
                );
              }
            },
          ),
          const SizedBox(width: 15)
        ],
      ),
      drawer: CustomDrawer(
        username: 'Sakib Anjum Arnab',
        email: 'arnab@example.com',
        profilePictureUrl: 'https://www.example.com/profile-picture.jpg',
        isBackupEnabled: false,
        onBackupToggle: (bool value) {
          // Handle backup toggle functionality here
        },
        onLogout: () => _logoutUser(context), // Logout functionality here
        onExit: () {
          // Handle exit functionality here
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: filteredTasks.isEmpty ? 1 : filteredTasks.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5 / 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (filteredTasks.isEmpty) {
              return GestureDetector(
                onTap: () => _addNewTask(),
                child: InfoCard(
                  task: Task(
                    id: 0,
                    title: 'Welcome to task manager',
                    description: 'Add your tasks.',
                    timeAndDate: '',
                    priority: '',
                    isChecked: false,
                  ),
                  onCheckboxChanged: null,
                  onDelete: null,
                ),
              );
            }
            final task = filteredTasks[index];
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
