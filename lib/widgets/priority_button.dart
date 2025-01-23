import 'package:flutter/material.dart';

class PriorityButton extends StatelessWidget {
  final String priority;

  const PriorityButton({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color getPriorityColor(String priority) {
      switch (priority.toLowerCase()) {
        case 'High':
          return Colors.red;
        case 'Medium':
          return Colors.orange;
        case 'Low':
          return Colors.green;
        default:
          return Colors.purple.shade100;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getPriorityColor(priority),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
