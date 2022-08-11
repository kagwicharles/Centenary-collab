import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  ThemeData appTheme = ThemeData(
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: Colors.blue,
          ),
      fontFamily: "Poppins",
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: const TextTheme(
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          )));
}
