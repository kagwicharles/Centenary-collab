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
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      ),
      backgroundColor: Color(0xff3988F0),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        labelSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        labelMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
            elevation: MaterialStateProperty.all(0.0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0))),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(58)))),
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
      ),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217))),
      contentPadding: const EdgeInsets.all(22),
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.grey[50],
    ),
    tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2.0,
              color: Colors.white,
            ),
            insets: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0))),
    scaffoldBackgroundColor: Color.fromARGB(255, 243, 248, 251),
  );
}
