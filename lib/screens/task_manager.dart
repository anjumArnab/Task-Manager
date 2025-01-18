import 'package:database_app/services/database_helper_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../widgets/info_card.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [];
    _loadTasks(); // Load tasks from the database on startup
  }

  // Load tasks from the database
  Future<void> _loadTasks() async {
    List<Task> taskList = await _databaseHelper.getTaskList(); // Updated method call
    setState(() {
      tasks = taskList;
    });
  }

  // Add a new task and save it to the database
  void _addNewTask() {
    _showTaskDetailsDialog(context, null, null);
  }

  // Delete task from database and UI
  void _deleteTask(int index) async {
    int result = await _databaseHelper.deleteTask(tasks[index].id!); // Updated method call
    if (result != 0) {
      setState(() {
        tasks.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Opacity(
            opacity: task.isChecked ? 0.5 : 1.0,
            child: GestureDetector(
              onTap: () => _showTaskDetailsDialog(context, task, index),
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

  // Task details dialog for both adding and editing tasks
  void _showTaskDetailsDialog(
      BuildContext context, Task? task, int? index) {
    final TextEditingController titleController =
        TextEditingController(text: task?.title ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: task?.description ?? '');
    final TextEditingController timeController =
        TextEditingController(text: task?.timeAndDate ?? '');
    String priority = task?.priority ?? 'Medium';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Time & Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          final TimeOfDay? pickedTime =
                              await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      DateTime.now()));
                          if (pickedTime != null) {
                            final DateTime finalDate = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            timeController.text = DateFormat(
                                    'yyyy-MM-dd, h:mm a')
                                .format(finalDate);
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: priority,
                  items: const [
                    DropdownMenuItem(
                      value: 'High',
                      child: Text('High'),
                    ),
                    DropdownMenuItem(
                      value: 'Medium',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'Low',
                      child: Text('Low'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) {
                    setState(() {
                      priority = value!;
                    });
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  if (task == null) {
                    Task newTask = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      timeAndDate: timeController.text,
                      priority: priority,
                      isChecked: false,
                    );
                    _databaseHelper.insertTask(newTask); // Updated method call
                    _loadTasks(); // Refresh task list from the DB
                  } else {
                    task.title = titleController.text;
                    task.description = descriptionController.text;
                    task.timeAndDate = timeController.text;
                    task.priority = priority;
                    _databaseHelper.updateTask(task); // Updated method call
                    _loadTasks(); // Refresh task list from the DB
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
