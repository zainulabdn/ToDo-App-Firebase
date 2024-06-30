import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haztech_task/Core/providers/signup_provider.dart';
import 'package:haztech_task/UI/Screens/Authentication/login_screen.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:haztech_task/UI/custom_widgets/custom_snackbars.dart';
import 'package:haztech_task/UI/custom_widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../../Core/Constants/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(builder: (context, signupProvider, child) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Center(
                    child: Text('Registration',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: kBlack)),
                  ),
                  const SizedBox(height: 5.0),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text('Please register yourself\n to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17, color: kBlack)),
                    ),
                  ),
                  const SizedBox(height: 70),
                  CustomTextField(
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 20,
                        color: kPrimaryColor,
                      ),
                      controller: nameController,
                      hintText: 'Name'),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: kPrimaryColor,
                      ),
                      hintText: 'Select Gender',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    value: selectedGender,
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                      prefixIcon: const Icon(
                        Icons.cake,
                        size: 20,
                        color: kPrimaryColor,
                      ),
                      controller: ageController,
                      hintText: 'Age'),
                  const SizedBox(height: 15),
                  CustomTextField(
                      prefixIcon: const Icon(
                        Icons.alternate_email,
                        color: kPrimaryColor,
                        size: 20,
                      ),
                      controller: emailController,
                      hintText: 'Email'),
                  const SizedBox(height: 15),
                  CustomTextField(
                    prefixIcon: const Icon(Icons.lock_open,
                        size: 20, color: kPrimaryColor),
                    controller: passController,
                    obscure: !signupProvider.isPasswordVisible,
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        signupProvider.togglePasswordVisibility();
                      },
                      icon: Icon(
                        size: 20,
                        signupProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Icons.lock_open,
                      size: 20,
                      color: kPrimaryColor,
                    ),
                    controller: conPassController,
                    obscure: !signupProvider.isPasswordVisible,
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        signupProvider.togglePasswordVisibility();
                      },
                      icon: Icon(
                        size: 20,
                        signupProvider.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  MyButtonLong(
                      name: 'Sign Up',
                      onTap: () {
                        if (emailController.text.isEmpty ||
                            nameController.text.isEmpty ||
                            passController.text.isEmpty ||
                            selectedGender == null ||
                            ageController.text.isEmpty) {
                          return CustomSnackBar.showError(
                              'Please fill all the fields');
                        } else {
                          signupProvider.signUpWithEmailAndPassword(
                              nameController.text,
                              emailController.text,
                              passController.text,
                              selectedGender.toString(),
                              ageController.text,
                              context);
                        }
                      }),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Already Registered?",
                        style: TextStyle(
                            fontSize: 15.0, color: kBlack.withOpacity(0.4)),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => LoginScreen(isAdmin: false));
                          },
                          child: const Text(
                            'Login Now',
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
