import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:rafiki/src/ui/auth/login.dart';
import 'package:rafiki/src/ui/home/adverts.dart';
import 'package:rafiki/src/ui/info/request_status.dart';
import 'package:rafiki/src/ui/others/map_view.dart';
import 'package:rafiki/src/utils/common_libs.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xffC92265), //or set color with: Color(0xFF0000FF)
    ));
    _checkPermissions();
    _checkDeviceRooted().then((value) => {
          debugPrint("Device root status...$value"),
          if (value)
            {
              CommonLibs.navigateToRoute(
                  context: context,
                  widget: RequestStatusScreen(
                      message: "This app cannot run on a rooted device!",
                      statusCode: "!")),
              Future.delayed(const Duration(milliseconds: 5000), () {
                exit(0);
              })
            }
        });
    var viewPadding = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
          SizedBox(
            height: viewPadding,
          ),
          Container(
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              margin: const EdgeInsets.all(8),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/bank.png",
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 44,
                  ),
                  const Text("Welcome to Centenary Bank",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600))
                ],
              ))),
          Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(20),
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: (.5 / .6),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                crossAxisCount: 3,
                children: <Widget>[
                  DashItem(
                    title: "Login",
                    widget: const Login(),
                    iconUrl: "assets/icons/lock.png",
                  ),
                  DashItem(
                    title: "Banks & Branches",
                    widget: const MapView(),
                    iconUrl: "assets/icons/atm_machine.png",
                  ),
                  DashItem(
                    title: "Internet Banking",
                    iconUrl: "assets/icons/checking.png",
                    isUrl: true,
                    launchUrl:
                        "https://centeonlinebanking.centenarybank.co.ug/iProfits2Prod/",
                  ),
                  DashItem(
                    title: "Cente on The Go",
                    iconUrl: "assets/icons/checking.png",
                    isUrl: true,
                    launchUrl:
                        "https://centeonlinebanking.centenarybank.co.ug/iProfits2Prod/",
                  ),
                ],
              ),
              const SizedBox(
                height: 44,
              ),
              AdvertsContainer(
                isFirstTimer: true,
              ),
            ],
          )
          // Expanded(child:
          // AdvertsContainer())
        ])));
  }

  _checkPermissions() async {
    await CommonLibs.checkReadPhoneStatePermission();
    await CommonLibs.checkContactsPermission();
    await CommonLibs.checkCameraPermission();
  }

  Future<bool> _checkDeviceRooted() async {
    debugPrint("Device IMEI: ${await CommonLibs.getDeviceUniqueID()}");
    bool _jailBroken = false;
    try {
      _jailBroken = await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      _jailBroken = true;
    }
    return _jailBroken;
  }
}

class DashItem extends StatelessWidget {
  DashItem(
      {Key? key,
      this.widget,
      this.isUrl = false,
      this.launchUrl,
      required this.title,
      required this.iconUrl})
      : super(key: key);

  Widget? widget;
  String? launchUrl;
  String title;
  String iconUrl;
  bool isUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 4,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            onTap: () {
              isUrl
                  ? CommonLibs.openUrl(Uri.parse(launchUrl!))
                  : CommonLibs.navigateToRoute(
                      context: context, widget: widget);
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconUrl,
                      height: 58,
                      width: 58,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    )
                  ],
                ))));
  }
}

class LandingPageItem {
  String title;
  String url;

  LandingPageItem({required this.title, required this.url});
}
