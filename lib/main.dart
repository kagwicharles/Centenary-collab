import 'package:flutter/material.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/ui/home/home.dart';
import 'package:rafiki/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TestEndpoint().getToken().then((res) => {
          TestEndpoint().getModules(),
          TestEndpoint().getForms(),
          TestEndpoint().getActionControls()
        });

    return MaterialApp(
      title: 'Rafiki',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().appTheme,
      home: HomePage(title: 'Rafiki'),
    );
  }
}
