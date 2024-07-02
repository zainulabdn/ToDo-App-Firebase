import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseHelper {
  /// Snack Bar Message on Success
  static showSnackBar(msg, {color, button}) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        msg,
        style: const TextStyle(
          color: Color(0xff155724),
        ),
      ),
      borderRadius: 5,
      barBlur: 5,
      backgroundColor: color ?? const Color(0xffD4EDDA),
      margin: const EdgeInsets.all(8),
      duration: const Duration(milliseconds: 2500),
      mainButton: button,
    ));
  }

  /// Error SnackBar
  static showErrorSnackBar(msg, {color, button}) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        msg,
        style: const TextStyle(
          color: Color(0xff721C24),
        ),
      ),
      borderRadius: 5,
      barBlur: 5,
      backgroundColor: color ?? const Color(0xffF8D7DA),
      margin: const EdgeInsets.all(5),
      duration: const Duration(milliseconds: 2500),
      mainButton: button,
    ));
  }
}
