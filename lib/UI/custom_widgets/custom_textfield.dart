// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../../Core/Constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final int maxline;
  final bool readOnly;
  final String? errorText;
  final String hintText;
  final bool? enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final validator;
  final double? fontSize;
  final String? label;
  final onSaved;
  final onTap;
  final bool disableBorder;
  final onChanged;
  final TextInputType? keyboardType;
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.onTap,
      this.disableBorder = false,
      this.maxline = 1,
      this.label,
      this.obscure = false,
      this.enabled = true,
      this.validator,
      this.errorText,
      this.fontSize = 15.0,
      required this.hintText,
      this.onSaved,
      this.suffixIcon,
      @required this.prefixIcon,
      this.onChanged,
      this.keyboardType,
      this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 65,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(15), // Set the border radius
      ),
      child: Center(
        child: TextFormField(
          maxLines: maxline,
          readOnly: readOnly,
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16.0),
          ),
          onTap: onTap,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
