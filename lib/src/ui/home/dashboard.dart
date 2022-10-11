import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:rafiki/src/ui/auth/login.dart';
import 'package:rafiki/src/ui/info/request_status.dart';
import 'package:rafiki/src/ui/others/map_view.dart';
import 'package:rafiki/src/utils/common_libs.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 24,
            ),
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(20),
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: (.5 / .6),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
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
              ],
            ),
            // Expanded(child:
            // AdvertsContainer())
          ],
        ));
  }

  Future<bool> _checkDeviceRooted() async {
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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
            elevation: 4,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            child: InkWell(
                onTap: () {
                  isUrl
                      ? CommonLibs.openUrl(Uri.parse(launchUrl!))
                      : CommonLibs.navigateToRoute(
                          context: context, widget: widget);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconUrl,
                      height: 44,
                      width: 44,
                    ),
                    const SizedBox(
                      height: 12,
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
