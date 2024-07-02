import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/assets.dart';
import 'package:haztech_task/Core/Constants/basehelper.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/Models/task_model.dart';
import 'package:haztech_task/Core/enums/task_sorting.dart';
import 'package:haztech_task/Core/notification_services.dart';
import 'package:haztech_task/Core/providers/task_provider.dart';
import 'package:haztech_task/UI/Screens/Authentication/choose_categories_view.dart';
import 'package:haztech_task/UI/Screens/Authentication/forgot_passwprd_screen.dart';
import 'package:haztech_task/UI/Screens/Task%20screeens/add_task_screen.dart';
import 'package:haztech_task/UI/Screens/Task%20screeens/quote_screen.dart';
import 'package:haztech_task/UI/Screens/categories/add_quotes_screen.dart';
import 'package:haztech_task/UI/Screens/feedback/feedback_view.dart';
import 'package:haztech_task/UI/Screens/graph/graph_screen.dart';
import 'package:haztech_task/UI/Screens/history/history_view.dart';
import 'package:haztech_task/UI/custom_widgets/task_block.dart';
import 'package:provider/provider.dart';

import '../../../Core/enums/task_filter.dart';
import '../../custom_widgets/delete_dialog.dart';
import '../../custom_widgets/setting_bottom_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.getUserName();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      debugPrint('======Device token======');
      debugPrint(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, child) {
      print("---------------->${taskProvider.fnamE}");
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 50,
          actions: [
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    OtherSettingsBottomSheet(
                      onFeedback: () {
                        Get.to(FeedbackScreen());
                      },
                      onHistory: () {
                        Get.to(const HistoryView());
                      },
                      onStatistics: () {
                        Get.to(TaskStatisticsScreen(
                          uid: taskProvider.user!.uid,
                        ));
                      },
                    ),
                    backgroundColor: Colors.white,
                  );
                },
                icon: const Icon(Icons.settings, color: Colors.black)),
          ],
          leading: InkWell(
            onTap: () {
              Get.bottomSheet(
                SettingsBottomSheet(
                  onlUsernameChanged: (value) {
                    taskProvider.updatelname(value);
                  },
                  fname: taskProvider.fnamE ?? '',
                  lname: taskProvider.lnamE ?? '',
                  onUpdateChangeCategories: () {
                    Get.to(() => const ChooseCategoryScreen());
                  },
                  age: taskProvider.agE ?? '',
                  gender: taskProvider.gendeR ?? '',
                  profilePicture: taskProvider.profilPicturE ?? '',
                  onProfilePictureUpdate: (value) async {
                    await taskProvider.uploadProfilePicture(value);
                    // taskProvider.updateProfilePhoto(value);
                  },
                  onUpdateChangePassword: () {
                    Get.to(() => ForgotPasswordScreen(
                          isChangePassword: true,
                        ));
                  },
                  isstatistics: false,
                  onStatistics: () {
                    Get.to(TaskStatisticsScreen(
                      uid: taskProvider.user!.uid,
                    ));
                  },
                  onUsernameChanged: (value) {
                    taskProvider.updatefname(value);
                  },
                  onAgeChanged: (value) {},
                  onGenderChanged: (value) {},
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                backgroundImage: taskProvider.profilPicturE != null &&
                        taskProvider.profilPicturE!.isNotEmpty
                    ? Image.network(taskProvider.profilPicturE!).image
                    : const AssetImage('assets/profile.png'),
              ),
            ),
          ),
          title: InkWell(
            onTap: () {
              Get.bottomSheet(
                isScrollControlled: true,
                SettingsBottomSheet(
                  onlUsernameChanged: (value) {
                    taskProvider.updatelname(value);
                  },
                  fname: taskProvider.fnamE ?? '',
                  lname: taskProvider.lnamE ?? '',
                  onUpdateChangeCategories: () {
                    Get.to(() => const ChooseCategoryScreen());
                  },
                  onUpdateChangePassword: () {
                    Get.to(() => ForgotPasswordScreen(
                          isChangePassword: true,
                        ));
                  },
                  onProfilePictureUpdate: (value) async {
                    await taskProvider.uploadProfilePicture(value);
                  },
                  isstatistics: false,
                  onStatistics: () {
                    Get.to(TaskStatisticsScreen(
                      uid: taskProvider.user!.uid,
                    ));
                  },
                  age: taskProvider.agE ?? '',
                  gender: taskProvider.gendeR ?? '',
                  profilePicture: taskProvider.profilPicturE ?? '',
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
              );
            },
            child: Row(
              children: [
                const Text('Hello ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quote Of The Day:',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        Get.to(AddQuoteScreen(
                          isUser: true,
                        ));
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: kPrimaryColor,
                      ))
                ],
              ),
              const SizedBox(height: 5),
              // Container(
              //   width: Get.width,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20), color: kWhite),
              //   child: Column(
              //     children: [
              //       const SizedBox(height: 10),
              //       Image.asset(Assets.quotesCommas, height: 25, width: 25),
              //       const SizedBox(height: 10),
              //       Text('You don\'t have to be great to start,',
              //           style: GoogleFonts.eduTasBeginner(fontSize: 18)),
              //       Text('but you have to start to be great',
              //           style: GoogleFonts.eduTasBeginner(fontSize: 18)),
              //       const SizedBox(height: 10),
              //       Text('- Zig Ziglar',
              //           style: GoogleFonts.nanumMyeongjo(fontSize: 12)),
              //       const SizedBox(height: 15),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),
              Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: kWhite),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(Assets.quotesCommas, height: 25, width: 25),
                      QuotesView(),
                    ],
                  )),
              const SizedBox(height: 20),
              const Text('ToDos:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor)),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Filter By',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kBlack),
                  ),
                  Spacer(),
                  Text(
                    'Sorted By',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kBlack),
                  ),
                ],
              ),
              Row(
                children: [
                  DropdownButton<TaskFilter>(
                    value: taskProvider.currentFilter,
                    onChanged: (TaskFilter? newValue) {
                      if (newValue != null) {
                        taskProvider.updateFilter(newValue);
                        taskProvider.updateSortOption(TaskSortOption.none);
                      }
                    },
                    items: TaskFilter.values.map((TaskFilter filter) {
                      String filterText = '';
                      if (filter == TaskFilter.all) {
                        filterText = 'All Tasks';
                      } else if (filter == TaskFilter.done) {
                        filterText = 'Done';
                      } else if (filter == TaskFilter.pending) {
                        filterText = 'Pending';
                      }
                      return DropdownMenuItem<TaskFilter>(
                        value: filter,
                        child: Text(
                          filterText,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  DropdownButton<TaskSortOption>(
                    value: taskProvider.currentOption,
                    onChanged: (TaskSortOption? newValue) {
                      if (newValue != null) {
                        taskProvider.updateSortOption(newValue);
                        taskProvider.updateFilter(TaskFilter.all);
                      }
                    },
                    items: TaskSortOption.values.map((TaskSortOption filter) {
                      String optionText = '';
                      if (filter == TaskSortOption.none) {
                        optionText = 'None';
                      } else if (filter == TaskSortOption.dueDate) {
                        optionText = 'Due date';
                      } else if (filter == TaskSortOption.creationDate) {
                        optionText = 'Create Date';
                      }
                      return DropdownMenuItem<TaskSortOption>(
                        value: filter,
                        child: Text(
                          optionText,
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<List<Task>>(
                  stream: taskProvider.taskStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final tasks = snapshot.data;

                      return tasks!.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Assets.nodata,
                                    height: 80,
                                  ),
                                  const Text(
                                    'No task available',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return Dismissible(
                                  key: Key(task.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (direction) async {
                                    taskProvider.deleteTask(task.id);
                                    BaseHelper.showSnackBar(
                                        'Task Deleted Successfully');
                                  },
                                  child: TaskBlock(
                                    title: task.title,
                                    description: task.description,
                                    onDelete: () async {
                                      final confirmed = await CustomDialog
                                          .showDeleteConfirmationDialog(
                                              context);
                                      if (confirmed != null && confirmed) {
                                        taskProvider.deleteTask(task.id);
                                        BaseHelper.showSnackBar(
                                            'Task Deleted Successfully');
                                      }
                                    },
                                    done: task.done,
                                    onDone: () {
                                      taskProvider.updateTaskStatus(
                                          task.id, !task.done);
                                    },
                                    latedone: task.lateDone,
                                    onLateDone: () {
                                      taskProvider.updateLateTaskStatus(
                                          task.id, !task.lateDone);
                                    },
                                    dueDate: task.dueDate,
                                    createDate: task.createDate,
                                  ),
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      return const Text('no data found');
                    } else if (!snapshot.hasData) {
                      return const Center(
                          child: Text('no data found',
                              style: TextStyle(color: kBlack, fontSize: 20)));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const AddTaskScreen(),
                  transition: Transition.leftToRight);
              // Get.to(ChooseCategoryScreen());
            },
            child: const Icon(Icons.add)),
      );
    });
  }
}
