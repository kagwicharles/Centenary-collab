import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class RequestStatusScreen extends StatelessWidget {
  RequestStatusScreen(
      {Key? key, required this.message, required this.statusCode})
      : super(key: key);

  String message;
  String statusCode;

  @override
  Widget build(BuildContext context) {
    Vibration.vibrate(duration: 500);
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: MediaQuery.of(context).size.height,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  getAvatarType(statusCode),
                  height: 54,
                  width: 54,
                ),
                const SizedBox(
                  height: 54,
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 54,
                ),
              ],
            )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close")),
            const SizedBox(
              height: 15,
            )
          ]),
    )));
  }

  String getAvatarType(String statusCode) {
    switch (statusCode) {
      case "000":
        return "assets/images/checked.png";

      case "099":
        return "assets/images/close.png";
    }
    return "assets/images/info.png";
  }
}
