import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as Storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haztech_task/Core/Constants/basehelper.dart';
import 'package:haztech_task/Core/enums/task_sorting.dart';
import 'package:haztech_task/UI/Screens/welcome/welcome_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_snackbars.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';
import '../Models/task_model.dart';
import '../enums/task_filter.dart';
import '../services/local_notification.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  String? fnamE;
  String? lnamE;

  String? agE;
  String? gendeR;
  String? profilPicturE;
  late Stream<List<Task>> _taskStream;
  TaskFilter currentFilter = TaskFilter.all;
  TaskSortOption currentOption = TaskSortOption.none;
  final Storage.FirebaseStorage _storage = Storage.FirebaseStorage.instance;

  Stream<List<Task>> get taskStream => _taskStream;
  DateTime? selectedDueDate;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TaskProvider() {
    _auth.authStateChanges().listen((User? user) {
      this.user = user;
      if (user != null) {
        getUserName();
        fetchTasks();
      } else {
        fnamE = null;
        lnamE = null;

        _taskStream = const Stream.empty();
        notifyListeners();
      }
    });
  }

  Future<void> addTask(
      String title, String description, BuildContext context) async {
    final ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      await _firestore.collection('tasks').add({
        'title': title,
        'description': description,
        'uid': user?.uid,
        'done': false,
        'late_done': false,
        'create_at': DateTime.now(),
        'start_date': selectedStartDate,
        'end_date': selectedEndDate,
      });

      await LocalNotificationService().scheduleNotification(
        id: 1,
        title: 'Task Reminder',
        body: 'Don\'t forget to complete your task, your task time ended',
        scheduledNotificationDateTime: selectedEndDate!,
      );

      dialog.dismiss();
      Get.back();
      BaseHelper.showSnackBar('Task Added Successfully');
    } catch (e) {
      dialog.dismiss();
      BaseHelper.showErrorSnackBar('Error adding task: $e');
      rethrow;
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final initialDate = selectedStartDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime != null) {
        selectedStartDate = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
        notifyListeners();
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final initialDate = selectedEndDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (pickedTime != null) {
        selectedEndDate = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
        notifyListeners();
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      debugPrint('Error deleting task: $e');
      rethrow;
    }
  }

  DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  void updateTaskStatus(String taskId, bool newStatus) {
    _firestore
        .collection('tasks')
        .doc(taskId)
        .update({'done': newStatus}).then((value) {
      debugPrint('Task status updated successfully');
    }).catchError((error) {
      debugPrint('Failed to update task status: $error');
    });
  }

  void updateLateTaskStatus(String taskId, bool newStatus) {
    _firestore
        .collection('tasks')
        .doc(taskId)
        .update({'late_done': newStatus}).then((value) {
      debugPrint('Task status updated successfully');
    }).catchError((error) {
      debugPrint('Failed to update task status: $error');
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final initialDate = selectedDueDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedDueDate = pickedDate;
      notifyListeners();
    }
  }

  Future<void> getUserName() async {
    try {
      final user = this.user;
      if (user != null) {
        final DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final fnamee = data['firstname'];
          final lnamee = data['lastname'];

          final age = data['age'];
          final gender = data['gender'];
          final profilePicture = data['profilePicture'];
          debugPrint('Username: $fnamE');
          debugPrint('age: $age');
          fnamE = fnamee;

          lnamE = lnamee;
          agE = age;
          gendeR = gender;
          profilPicturE = profilePicture;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error getting user name: $e');
      rethrow;
    }
  }

  void updatefname(String fname) {
    fnamE = fname;

    notifyListeners();
  }

  void updatelname(String lname) {
    lnamE = lname;

    notifyListeners();
  }

  void updateAge(String age) {
    agE = age;

    notifyListeners();
  }

  void updateGender(String gender) {
    gendeR = gender;

    notifyListeners();
  }

  void updateProfilePhoto(String profile) {
    profilPicturE = profile;

    notifyListeners();
  }

  void updateUserData() {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = userCollection.doc(user?.uid);

    userDoc.update({
      'firstname': fnamE,
      'lastname': lnamE,
      'age': agE,
      'gender': gendeR,
      'profilePicture': profilPicturE
    }).then((_) {
      CustomSnackBar.showSuccess('Profile Update Successfully');
      notifyListeners();
    }).catchError((error) {
      CustomSnackBar.showError('Error updating user data: $error');
    });
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      final userId = user?.uid;
      if (userId == null) return;

      final storageRef = _storage.ref().child('profile_pictures/$userId.jpg');
      await storageRef.putFile(imageFile);

      final downloadUrl = await storageRef.getDownloadURL();
      profilPicturE = downloadUrl;

      await _firestore.collection('users').doc(userId).update({
        'profilePicture': downloadUrl,
      });

      CustomSnackBar.showSuccess('Profile picture updated successfully');
      notifyListeners();
    } catch (e) {
      CustomSnackBar.showError('Error uploading profile picture: $e');
      debugPrint('Error uploading profile picture: $e');
    }
  }

  void logout() async {
    try {
      await _auth.signOut();
      // Clear the provider state
      fnamE = null;
      lnamE = null;

      selectedDueDate = null;
      _taskStream = const Stream.empty();
      notifyListeners();
      BaseHelper.showSnackBar('Logout successfully');
      Get.offAll(() => const WelComeScreen());
    } catch (e) {
      debugPrint('Error signing out: $e');
      BaseHelper.showErrorSnackBar('Error signing out: $e');
      rethrow;
    }
  }

  void fetchTasks() {
    if (user == null) return;

    Query query =
        _firestore.collection('tasks').where('uid', isEqualTo: user?.uid);

    switch (currentFilter) {
      case TaskFilter.done:
        query = query.where('done', isEqualTo: true);
        break;
      case TaskFilter.pending:
        query = query.where('done', isEqualTo: false);
        break;
      case TaskFilter.all:
        // No additional filters needed for 'all'
        break;
    }

    if (currentOption == TaskSortOption.dueDate) {
      query = query.orderBy('end_date');
    } else if (currentOption == TaskSortOption.creationDate) {
      query = query.orderBy('create_at');
    }

    _taskStream = query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList());
    notifyListeners();
  }

  void updateFilter(TaskFilter newFilter) {
    if (currentFilter != newFilter) {
      currentFilter = newFilter;
      fetchTasks();
    }
  }

  void updateSortOption(TaskSortOption sortOption) {
    if (currentOption != sortOption) {
      currentOption = sortOption;
      fetchTasks();
    }
  }
}
