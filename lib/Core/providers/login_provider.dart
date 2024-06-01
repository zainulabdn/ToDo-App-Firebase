import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/Constants/basehelper.dart';
import 'package:haztech_task/UI/Screens/Task%20screeens/tasks_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_snackbars.dart';
import 'package:haztech_task/admin/screens/admin_home_screen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Save user's UUID in SharedPreferences
      await saveUserUUID(userCredential.user!.uid);
      BaseHelper.showSnackBar('Login Successfully');
      dialog.dismiss();
      if (email == 'admin@admin.com' && password == '12345678') {
        Get.offAll(() => const AdminHomeScreen());
      } else {
        Get.offAll(() => const TasksScreen());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => TasksScreen()),
        // );
      }
    } catch (e) {
      BaseHelper.showErrorSnackBar('Invalid Credentials');
      dialog.dismiss();
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    ProgressDialog dialog = ProgressDialog(context,
        title: const Text('Loading'), message: const Text('Please wait'));
    try {
      dialog.show();
      await _auth.sendPasswordResetEmail(email: email);
      CustomSnackBar.showSuccess('Password reset email sent');
      dialog.dismiss();
    } catch (e) {
      CustomSnackBar.showError('Error sending password reset email: $e');
      dialog.dismiss();
      rethrow;
    }
  }

  Future<void> saveUserUUID(String uuid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uuid', uuid);
  }
}
