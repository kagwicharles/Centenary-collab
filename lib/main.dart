import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/ui/auth/activation.dart';
import 'package:rafiki/src/ui/auth/login.dart';
import 'package:rafiki/theme/app_theme.dart';

void main() {
  getAppData();
  runApp(const MyApp());
}

getAppData() async {
  TestEndpoint().getToken().then((res) async => {
        TestEndpoint().getUIData(FormId.MENU),
        TestEndpoint().getUIData(FormId.FORMS),
        TestEndpoint().getUIData(FormId.ACTIONS),
        TestEndpoint().getStaticData()
      });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rafiki',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().appTheme,
      // home: HomePage(title: 'Rafiki'),
      home: Login(),
    );
  }
}
