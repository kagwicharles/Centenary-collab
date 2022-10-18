import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rafiki/src/data/local/shared_pref/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonLibs {
  static Future<void> openUrl(Uri url) async {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  static navigateToRoute({required context, required widget}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static getDeviceUniqueID() async {
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return await UniqueIdentifier.serial; //01e02c9a66c8611d
    // return androidInfo.id; //SP1A.210812.016
    // return await DeviceInformation.deviceIMEINumber; //188439113945710
  }

  static checkReadPhoneStatePermission() async {
    if (await Permission.phone.status.isDenied) {
      await Permission.phone.request();
    }
  }

  static checkContactsPermission() async {
    if (await Permission.contacts.status.isDenied) {
      await Permission.contacts.request();
    }
  }

  static checkCameraPermission() async {
    if (await Permission.camera.status.isDenied) {
      await Permission.camera.request();
    }
  }

  static checkActivationStatus() async {
    debugPrint("Checking activation data...");
    final _sharedPref = SharedPrefLocal();
    String? customerMobile = await _sharedPref.getCustomerMobile();
    String? customerID = await _sharedPref.getCustomerID();
    if (customerID == null || customerMobile == null) {
      return false;
    }
    return true;
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning!';
    }
    if (hour < 17) {
      return 'Afternoon!';
    }
    return 'Evening!';
  }
}
