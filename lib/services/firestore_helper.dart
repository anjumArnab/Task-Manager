import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Backup all tasks to Firestore
  Future<void> backupTasksToFirestore(List<Task> tasks) async {
    try {
      // Reference to the Firestore collection
      CollectionReference tasksCollection = _firestore.collection('tasks');

      for (Task task in tasks) {
        // Check if the task already exists in Firestore by ID
        final QuerySnapshot existingTask = await tasksCollection
            .where('id', isEqualTo: task.id)
            .get();

        if (existingTask.docs.isEmpty) {
          // Add new task if it doesn't exist
          await tasksCollection.add(task.toMap());
        } else {
          // Update existing task if it exists
          await tasksCollection.doc(existingTask.docs.first.id).update(task.toMap());
        }
      }
      print('All tasks have been backed up to Firestore.');
    } catch (e) {
      print('Error backing up tasks to Firestore: $e');
    }
  }

  /// Fetch all tasks from Firestore
  Future<List<Task>> fetchTasksFromFirestore() async {
    try {
      CollectionReference tasksCollection = _firestore.collection('tasks');
      final QuerySnapshot querySnapshot = await tasksCollection.get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Task.fromMapObject(data);
      }).toList();
    } catch (e) {
      print('Error fetching tasks from Firestore: $e');
      return [];
    }
  }
}
