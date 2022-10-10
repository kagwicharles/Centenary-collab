import 'package:flutter/material.dart';

class RequestStatusScreen extends StatelessWidget {
  RequestStatusScreen({Key? key, this.message, this.statusCode})
      : super(key: key);

  String? message;
  String? statusCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: MediaQuery.of(context).size.height,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              getAvatarType(statusCode!),
              height: 54,
              width: 54,
            ),
            const SizedBox(
              height: 54,
            ),
            Text(
              message!,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 54,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"))
          ]),
    )));
  }

  String getAvatarType(String statusCode) {
    switch (statusCode) {
      case "000":
        return "assets/images/checked.png";
    }
    return "assets/images/close.png";
  }
}
