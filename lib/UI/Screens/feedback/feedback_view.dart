import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});
  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
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
        padding: const EdgeInsets.all(8.0),
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
          ],
        ),
      ),
    );
  }
}
