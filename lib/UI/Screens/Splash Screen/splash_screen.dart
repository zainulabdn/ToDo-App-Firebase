import 'package:flutter/material.dart';
import 'package:haztech_task/Core/Constants/assets.dart';
import 'package:haztech_task/UI/Screens/Authentication/login_screen.dart';
import 'package:haztech_task/UI/Screens/welcome/welcome_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WelComeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: FadeTransition(
      //   opacity: _animation,
      //   child: const Center(
      //     child: FlutterLogo(size: 150.0, style: FlutterLogoStyle.stacked),
      //   ),
      // ),
      body: Center(
        child: Lottie.asset(Assets.splashAnimation),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
