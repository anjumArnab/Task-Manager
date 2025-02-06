import 'package:database_app/screens/task_manager.dart';
import 'package:database_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';

class CreateTaskPage extends StatefulWidget {
  final Task? task;
  final int? taskIndex;

  const CreateTaskPage({super.key, this.task, this.taskIndex});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String priority = 'Medium';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Set existing task details
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      timeController.text = widget.task!.timeAndDate;
      priority = widget.task!.priority;
    } else {
      // Set initial time to current device time and date
      timeController.text =
          DateFormat('yyyy-MM-dd, h:mm a').format(DateTime.now());
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          timeController.text =
              DateFormat('yyyy-MM-dd, h:mm a').format(finalDateTime);
        });
      }
    }
  }

  Widget _buildPriorityButton(String priorityValue, Color color) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              priority == priorityValue ? color : Colors.grey.shade300,
          foregroundColor:
              priority == priorityValue ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            priority = priorityValue;
          });
        },
        child: Text(priorityValue),
      ),
    );
  }

  void _saveTask() async {
    if (widget.task == null) {
      Task newTask = Task(
        title: titleController.text,
        description: descriptionController.text,
        timeAndDate: timeController.text,
        priority: priority,
        isChecked: false,
      );
      await _databaseHelper.insertTask(newTask);
    } else {
      widget.task!.title = titleController.text;
      widget.task!.description = descriptionController.text;
      widget.task!.timeAndDate = timeController.text;
      widget.task!.priority = priority;
      await _databaseHelper.updateTask(widget.task!);
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              const TaskManager()), // Replace `HomeScreen` with your actual home screen widget.
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                maxLines: 3, // Allow the description field to have 5 lines
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: timeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Time & Date',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    onPressed: _selectDateTime,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriorityButton('High', Colors.red),
                  const SizedBox(width: 10),
                  _buildPriorityButton('Medium', Colors.orange),
                  const SizedBox(width: 10),
                  _buildPriorityButton('Low', Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _saveTask,
                text: widget.task == null ? 'Done' : 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
