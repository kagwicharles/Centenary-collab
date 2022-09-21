import 'package:flutter/material.dart';

class CommonWidgets {
  static var snackBarDuration = const Duration(seconds: 4);
  static const snackBarBehavior = SnackBarBehavior.floating;
  static var errorColor = Colors.red;
  static var successColor = Colors.green[600];

  static buildNormalSnackBar({context, message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: snackBarDuration,
          content: Text(message),
          behavior: snackBarBehavior,
          backgroundColor: Color(0xffC92265)),
    );
  }
}
