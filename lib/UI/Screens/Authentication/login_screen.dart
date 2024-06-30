import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:haztech_task/Core/Constants/basehelper.dart';
import 'package:haztech_task/Core/Constants/extension.dart';
import 'package:haztech_task/UI/Screens/Authentication/forgot_passwprd_screen.dart';
import 'package:haztech_task/UI/Screens/Authentication/signup_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/custom_snackbars.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constants/colors.dart';
import '../../../Core/providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  bool isAdmin;
  LoginScreen({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, loginProvider, child) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.heightBox,
                  const Center(
                    child: Text('Hello Again!',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: kBlack)),
                  ),
                  5.heightBox,
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Welcome back you have\n been missed',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17, color: kBlack),
                      ),
                    ),
                  ),
                  70.heightBox,
                  widget.isAdmin
                      ? const Text('Admin Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))
                      : const Text('Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                  20.heightBox,
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.alternate_email,
                      color: kPrimaryColor,
                    ),
                    controller: emailController,
                    hintText: 'Email',
                  ),
                  15.heightBox,
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.lock_open,
                      color: kPrimaryColor,
                    ),
                    controller: passController,
                    obscure: !loginProvider.isPasswordVisible,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        loginProvider.togglePasswordVisibility();
                      },
                      icon: Icon(
                        loginProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  widget.isAdmin
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => ForgotPasswordScreen());
                            },
                            child: const Text(
                              'Recovery Password',
                              style: TextStyle(color: kBlack),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  MyButtonLong(
                      name: 'Sign In',
                      onTap: () {
                        if (emailController.text.isEmpty ||
                            passController.text.isEmpty) {
                          return BaseHelper.showErrorSnackBar(
                              'Please fill all the fields');
                        }
                        loginProvider.signInWithEmailAndPassword(
                            emailController.text, passController.text, context);
                      }),
                  const SizedBox(height: 20.0),
                  widget.isAdmin
                      ? const SizedBox()
                      : const Row(
                          children: [
                            SizedBox(width: 20),
                            Expanded(child: Divider(color: kBlack)),
                            SizedBox(width: 20),
                            Text('OR'),
                            SizedBox(width: 20),
                            Expanded(child: Divider(color: kBlack)),
                            SizedBox(width: 20),
                          ],
                        ),
                  widget.isAdmin
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Not a Member?",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: kBlack.withOpacity(0.4)),
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.to(() => const SignUpScreen());
                                },
                                child: const Text(
                                  'Register Now',
                                  style: TextStyle(color: kBlack),
                                ))
                          ],
                        ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
