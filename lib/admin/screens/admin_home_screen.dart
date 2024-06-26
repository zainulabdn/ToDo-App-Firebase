import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Constants/extension.dart';
import 'package:haztech_task/Core/providers/task_provider.dart';
import 'package:haztech_task/UI/Screens/categories/add_quotes_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/setting_bottom_sheet.dart';
import 'package:haztech_task/admin/allUsers/all_users_list.dart';
import 'package:haztech_task/admin/feedback/user_feedback_view.dart';
import 'package:provider/provider.dart';

import '../../UI/Screens/categories/categories_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 50,
          actions: [
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    SettingsBottomSheet(
                      isstatistics: false,
                      onStatistics: () {},
                      username: taskProvider.username.toString(),
                      onUsernameChanged: (value) {
                        taskProvider.updateUsername(value);
                      },
                      onUpdatePressed: () {
                        taskProvider.updateUserData();
                        Get.back();
                      },
                      onLogoutPressed: () {
                        taskProvider.logout();
                        Get.back();
                      },
                    ),
                    backgroundColor: Colors.white,
                  );
                },
                icon: const Icon(Icons.settings, color: Colors.black)),
          ],
          leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(child: Icon(Icons.person))),
          title: Row(
            children: [
              const Text(
                'Dashboard ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              taskProvider.username == null
                  ? const CircularProgressIndicator()
                  : Text(
                      taskProvider.username.toString(),
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 17,
                      ),
                    ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              const Text(
                'Features:',
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              20.heightBox,
              MyButtonLong(
                  name: 'Add Motivational Quotes',
                  onTap: () {
                    Get.to(AddQuoteScreen());
                  }),
              10.heightBox,
              MyButtonLong(
                  name: 'Add Categories',
                  onTap: () {
                    Get.to(AddCategoryScreen(),
                        transition: Transition.leftToRight);
                  }),
              10.heightBox,
              MyButtonLong(
                  name: 'Check User Feedbacks',
                  onTap: () {
                    Get.to(UserFeedBackList());
                  }),
              10.heightBox,
              MyButtonLong(
                  name: 'All Users List',
                  onTap: () {
                    Get.to(UserListScreen());
                  }),
              10.heightBox,
            ],
          ),
        ),
      );
    });
  }
}
