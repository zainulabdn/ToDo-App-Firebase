import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:haztech_task/Core/Constants/assets.dart';
import 'package:haztech_task/Core/Constants/extension.dart';
import 'package:haztech_task/UI/custom_widgets/custom_buttons.dart';
import 'package:lottie/lottie.dart';

class WelComeScreen extends StatelessWidget {
  const WelComeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Lottie.asset(Assets.getStarted5,
                height: Get.height / 2, width: Get.width),
            Spacer(),
            MyButtonLong(name: 'User', onTap: () {}),
            15.heightBox,
            MyButtonLong(name: 'Admin', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
