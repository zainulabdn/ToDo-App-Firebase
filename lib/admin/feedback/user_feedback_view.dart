import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';

class UserFeedBackList extends StatelessWidget {
  const UserFeedBackList({super.key});

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
          'User Feedbacks',
          style: TextStyle(color: kBlack),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var feedbackDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              var feedback = feedbackDocs[index];
              return FeedbackItem(
                title: feedback['title'],
                email: feedback['email'],
                description: feedback['description'],
                timestamp: feedback['timestamp']?.toDate(),
              );
            },
          );
        },
      ),
    );
  }
}

class FeedbackItem extends StatelessWidget {
  final String title;
  final String email;
  final String description;
  final DateTime? timestamp;

  const FeedbackItem({
    Key? key,
    required this.title,
    required this.email,
    required this.description,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format timestamp using intl package
    String formattedDate = timestamp != null
        ? DateFormat('dd-MMM-yyyy').add_jm().format(timestamp!)
        : 'Unknown';

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 4),
            Text(
              'Submitted on: $formattedDate',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
