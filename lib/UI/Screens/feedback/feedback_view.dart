import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/basehelper.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          'Feedback',
          style: TextStyle(color: kBlack),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              prefixIcon: const Icon(
                Icons.title,
                color: kPrimaryColor,
              ),
              controller: titleController,
              hintText: 'Title',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              prefixIcon: const Icon(
                Icons.email,
                color: kPrimaryColor,
              ),
              controller: emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              maxline: 3,
              prefixIcon: const Icon(
                Icons.description,
                color: kPrimaryColor,
              ),
              controller: descriptionController,
              hintText: 'Description...',
            ),
            const SizedBox(height: 15),
            MyButtonLong(
                name: 'Submit',
                onTap: () {
                  if (emailController.text.isEmpty ||
                      titleController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    return BaseHelper.showErrorSnackBar(
                        'Please fill all the fields');
                  }
                  saveFeedback(
                    titleController.text,
                    emailController.text,
                    descriptionController.text,
                  );
                  BaseHelper.showSnackBar('Submitted');
                  emailController.clear();
                  titleController.clear();
                  descriptionController.clear();
                }),
          ],
        ),
      ),
    );
  }

  void saveFeedback(String title, String email, String description) async {
    User? user = _auth.currentUser;
    if (user == null) {
      BaseHelper.showErrorSnackBar('User not logged in');
      return;
    }

    String uid = user.uid;
    FirebaseFirestore.instance.collection('feedback').add({
      'uid': uid,
      'title': title,
      'email': email,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      BaseHelper.showSnackBar('Feedback submitted successfully');
    }).catchError((error) {
      BaseHelper.showErrorSnackBar('Error submitting feedback: $error');
    });
  }
}
