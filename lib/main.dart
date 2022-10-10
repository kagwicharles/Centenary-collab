import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/theme/app_theme.dart';

import 'src/ui/home/dashboard.dart';

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
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor:  Color(0xffC92265), //or set color with: Color(0xFF0000FF)
    // ));
    return MaterialApp(
      title: 'Rafiki',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().appTheme,
      // home: HomePage(title: 'Rafiki'),
      home: const DashBoard(),
      builder: EasyLoading.init(),
    );
  }
}
