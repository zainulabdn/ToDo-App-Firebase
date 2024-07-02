import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Constants/extension.dart';
import 'package:haztech_task/Core/providers/task_provider.dart';
import 'package:haztech_task/UI/Screens/Authentication/choose_categories_view.dart';
import 'package:haztech_task/UI/Screens/Authentication/forgot_passwprd_screen.dart';
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
                    AdminSettingsBottomSheet(
                      onlUsernameChanged: (value) {
                        taskProvider.updatelname(value);
                      },
                      onUpdateChangeCategories: () {
                        Get.to(() => const ChooseCategoryScreen());
                      },
                      onUpdateChangePassword: () {
                        Get.to(() => ForgotPasswordScreen(
                              isChangePassword: true,
                            ));
                      },
                      profilePicture: taskProvider.profilPicturE ?? '',
                      onProfilePictureUpdate: (value) async {
                        // taskProvider.updateProfilePhoto(value);
                        await taskProvider.uploadProfilePicture(value);
                      },
                      age: taskProvider.agE ?? '',
                      gender: taskProvider.gendeR ?? '',
                      isstatistics: false,
                      onStatistics: () {},
                      fname: taskProvider.fnamE ?? '',
                      lname: taskProvider.lnamE ?? '',
                      onUsernameChanged: (value) {
                        taskProvider.updatefname(value);
                      },
                      onAgeChanged: (value) {
                        taskProvider.updateAge(value);
                      },
                      onGenderChanged: (value) {
                        taskProvider.updateGender(value);
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
                    isScrollControlled: true,
                  );
                },
                icon: const Icon(Icons.settings, color: Colors.black))
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
              taskProvider.fnamE == null
                  ? const CircularProgressIndicator()
                  : Text(
                      taskProvider.fnamE.toString() +
                          taskProvider.lnamE.toString(),
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
                    Get.to(const UserFeedBackList());
                  }),
              10.heightBox,
              MyButtonLong(
                  name: 'All Users List',
                  onTap: () {
                    Get.to(const UserListScreen());
                  }),
              10.heightBox,
            ],
          ),
        ),
      );
    });
  }
}
