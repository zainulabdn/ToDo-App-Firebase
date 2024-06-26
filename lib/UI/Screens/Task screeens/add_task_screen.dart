import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/providers/task_provider.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/custom_snackbars.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back, color: kBlack)),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Add Task',
            style: TextStyle(color: kBlack),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/add.png',
                    height: 200,
                  ),
                ),
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
                    Icons.description,
                    color: kPrimaryColor,
                  ),
                  controller: descriptionController,
                  hintText: 'Description...',
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: kPrimaryColor,
                  ),
                  controller: TextEditingController(
                      text: taskProvider.selectedStartDate != null
                          ? DateFormat('yyyy-MM-dd HH:mm')
                              .format(taskProvider.selectedStartDate!)
                          : 'Start Date'),
                  hintText: 'Start Date',
                  onTap: () {
                    taskProvider.selectStartDate(context);
                  },
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: kPrimaryColor,
                  ),
                  controller: TextEditingController(
                      text: taskProvider.selectedEndDate != null
                          ? DateFormat('yyyy-MM-dd HH:mm')
                              .format(taskProvider.selectedEndDate!)
                          : 'End Date'),
                  hintText: 'End Date',
                  onTap: () {
                    taskProvider.selectEndDate(context);
                  },
                ),
                const SizedBox(height: 40.0),
                MyButtonLong(
                    name: 'Add Task',
                    onTap: () {
                      if (titleController.text.isEmpty) {
                        return CustomSnackBar.showError('Please provide title');
                      }
                      taskProvider.addTask(titleController.text,
                          descriptionController.text, context);
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
