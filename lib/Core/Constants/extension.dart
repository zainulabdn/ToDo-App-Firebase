// Extension on String for quick text widget creation
import 'package:flutter/material.dart';

extension on String {
  Widget textWidget() {
    return Text(this);
  }
}

// Extension on Widget for padding
extension PaddingExtension on Widget {
  Widget withPadding([EdgeInsetsGeometry padding = const EdgeInsets.all(8.0)]) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}

// Extension on int for quick SizedBox creation
extension SizeBoxExtension on int {
  Widget get heightBox => SizedBox(height: toDouble());
  Widget get widthBox => SizedBox(width: toDouble());
}
