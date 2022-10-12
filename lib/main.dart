import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/theme/app_theme.dart';
import 'src/ui/home/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _sharedPrefLocal = SharedPrefLocal();
  final _services = TestEndpoint();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor:  Color(0xffC92265), //or set color with: Color(0xFF0000FF)
    // ));
    getAppData();

    return MaterialApp(
      title: 'Rafiki',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().appTheme,
      // home: HomePage(title: 'Rafiki'),
      home: const DashBoard(),
      builder: EasyLoading.init(),
    );
  }

  getAppData() async {
    int? staticDataVersion = await _sharedPrefLocal.getStaticDataVersion();
    debugPrint("Current data version...$staticDataVersion");
    _services.getToken().then((res) async => {
          if (staticDataVersion == null)
            {
              _services.getUIData(FormId.MENU),
              _services.getUIData(FormId.FORMS),
              _services.getUIData(FormId.ACTIONS),
              _services.getStaticData()
            }
          else
            {
              _services.getStaticData(
                  currentStaticDataVersion: staticDataVersion)
            }
        });
  }
}
