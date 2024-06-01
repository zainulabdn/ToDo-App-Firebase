import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String title;
  final String id;
  final bool done;
  final bool lateDone;
  final DateTime dueDate;
  final DateTime startDate;

  final DateTime createDate;
  final String description;

  Task(this.title, this.description, this.id, this.done, this.dueDate,
      this.lateDone, this.startDate, this.createDate);

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        title = snapshot['title'],
        done = snapshot['done'],
        lateDone = snapshot['late_done'],
        dueDate = (snapshot['end_date'] as Timestamp).toDate(),
        startDate = (snapshot['start_date'] as Timestamp).toDate(),
        createDate = (snapshot['create_at'] as Timestamp).toDate(),
        description = snapshot['description'];
}
