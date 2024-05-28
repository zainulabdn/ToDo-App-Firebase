import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haztech_task/Core/Constants/assets.dart';
import 'package:haztech_task/Core/Constants/colors.dart';
import 'package:haztech_task/Core/enums/task_sorting.dart';
import 'package:haztech_task/Core/notification_services.dart';
import 'package:haztech_task/Core/providers/task_provider.dart';
import 'package:haztech_task/UI/Screens/Authentication/choose_categories_view.dart';
import 'package:haztech_task/UI/Screens/Task%20screeens/add_task_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_snackbars.dart';
import 'package:haztech_task/UI/custom_widgets/task_block.dart';
import 'package:provider/provider.dart';

import '../../../Core/enums/task_filter.dart';
import '../../custom_widgets/delete_dialod.dart';
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
    TaskProvider().getUserName();
    notificationServices.requestNotificationPermission();
    notificationServices.getDeviceToken().then((value) {
      debugPrint('======Device token======');
      debugPrint(value);
    });
  }

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
              const Text('Hello ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 10),
              const Text(
                'Quote Of The Day:',
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: kWhite),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(Assets.quotesCommas, height: 25, width: 25),
                    const SizedBox(height: 10),
                    Text('You don\'t have to be great to start,',
                        style: GoogleFonts.eduTasBeginner(fontSize: 18)),
                    Text('but you have to start to be great',
                        style: GoogleFonts.eduTasBeginner(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('- Zig Ziglar',
                        style: GoogleFonts.nanumMyeongjo(fontSize: 12)),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
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
                child: StreamBuilder(
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
                                    CustomSnackBar.showSuccess(
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
                                        CustomSnackBar.showSuccess(
                                            'Task Deleted Successfully');
                                      }
                                    },
                                    done: task.done,
                                    onDone: () {
                                      taskProvider.updateTaskStatus(
                                          task.id, !task.done);
                                    },
                                    dueDate: task.dueDate,
                                    createDate: task.createDate,
                                  ),
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
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
