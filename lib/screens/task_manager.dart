import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart'; // Ensure your Task model is correctly imported
import '../widgets/info_card.dart'; // Updated import path for InfoCard widget

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final List<Task> tasks = [
    Task(
      title: 'Complete Flutter Project',
      description: 'Build a complete Flutter app with REST API integration.',
      timeAndDate: '2025-01-16, 10:00 AM',
      priority: 'High',
      isChecked: false,
    ),
    Task(
      title: 'Finish Homework',
      description: 'Complete the homework for Computer Science course.',
      timeAndDate: '2025-01-17, 2:00 PM',
      priority: 'Medium',
      isChecked: false,
    ),
    Task(
      title: 'Meeting with Team',
      description: 'Discuss project progress with the team.',
      timeAndDate: '2025-01-18, 9:00 AM',
      priority: 'Low',
      isChecked: false,
    ),
  ];

  void _addNewTask() {
    _showTaskDetailsDialog(context, null, null);
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
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
          backgroundColor: Colors.blue.shade300, // Background color for the button
          elevation: 8, // Adds shadow effect for better visibility
          child: const Icon(
            Icons.task, // Icon representing adding a new card
            color: Colors.white, // Makes the icon color white for contrast
            size: 30, // Size of the icon
          ),
        ),
      ),
    );
  }

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
          contentPadding: const EdgeInsets.all(20), // Increases the padding around content
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
              onPressed: () {
                setState(() {
                  if (task == null) {
                    tasks.insert(0, Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      timeAndDate: timeController.text,
                      priority: priority,
                      isChecked: false,
                    ));
                  } else {
                    tasks[index!] = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      timeAndDate: timeController.text,
                      priority: priority,
                      isChecked: task.isChecked,
                    );
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
