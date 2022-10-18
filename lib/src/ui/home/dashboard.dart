import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:rafiki/src/ui/auth/login.dart';
import 'package:rafiki/src/ui/home/adverts.dart';
import 'package:rafiki/src/ui/home/social.dart';
import 'package:rafiki/src/ui/info/request_status.dart';
import 'package:rafiki/src/ui/onTheGO/on_the_go_landing.dart';
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
              // height: 500,
              child: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/mapeera_house.jpg",
                    ),
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.darken,
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(18.0),
                    bottomLeft: Radius.circular(18.0))),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good",
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                Text(
                                  CommonLibs.greeting(),
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 24,
                      ),
                      Material(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Container(
                            height: 144,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome To",
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Text(
                                  "Centenary Mobile Banking",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    CommonLibs.navigateToRoute(
                                        context: context,
                                        widget: const Login());
                                  },
                                  child: const Text("LOGIN"),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 24,
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: (.5 / .6),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        crossAxisCount: 3,
                        children: <Widget>[
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
                            title: "Cente On The Go",
                            widget: const OnTheGOLanding(),
                            iconUrl: "assets/icons/onTheGo.png",
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ])),
          )),
          Material(
              child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              AdvertsContainer(
                isFirstTimer: true,
              ),
              const SizedBox(
                height: 24,
              ),
              SocialContainer(),
            ],
          ))
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.white, width: 1.5),
        ),
        color: Colors.black.withOpacity(0.1),
        child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
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
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
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
