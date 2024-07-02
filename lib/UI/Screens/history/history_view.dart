import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<Task>? tasks;
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  void fetchUserId() async {
    // Fetch the current user ID
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      fetchTasks(user.uid);
    }
  }

  void fetchTasks(String userId) {
    FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      setState(() {
        tasks =
            querySnapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
      });
    }).catchError((error) {
      print('Error fetching tasks: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: kBlack),
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          'History',
          style: TextStyle(color: kBlack),
        ),
      ),
      body: tasks != null
          ? ListView.builder(
              itemCount: tasks!.length,
              itemBuilder: (context, index) {
                return buildTaskItem(tasks![index]);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTaskItem(Task task) {
    // Determine the task status
    String status;
    Color statusColor;

    if (task.done) {
      status = 'Done';
      statusColor = Colors.green;
    } else if (task.lateDone) {
      status = 'Late Done';
      statusColor = Colors.red;
    } else {
      status = 'Pending';
      statusColor = Colors.yellow;
    }
    String formattedDate = DateFormat('yyyy-MM-dd').format(task.createDate);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'Status: ',
                ),
                Text(
                  status,
                  style: TextStyle(color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Created At: $formattedDate'), // Display the formatted date
          ],
        ),
      ),
    );
  }
}
