import 'dart:async';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:uuid/uuid.dart';

class Constants {
  static const test = true;
  static const uat = "https://uat.craftsilicon.com";
  static const live = "https://app.craftsilicon.com";

  static const appName = "CENTEMOBILE";
  static const codeBase = "ANDROID";
  static const device = "e3623c468d9ddcd5";
  static const mobileNumber = "4570670220";
  static const rashi =
      "ccd7216a4fe5ddd5dd1d48a55072b62b868f55f88646abae1a83a30a9ec70b08";
  static const uniqueId = "00000000-7440-856d-0000-00001d093e12";
  static var uuid = const Uuid();
  static const bankCustomerId = "4570670220";
  static const country = "UGANDATEST";

  var version = "";

  Constants() {
    getPackageName();
  }

  void getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.packageName;
  }

  static getImei() async {
    return UniqueIdentifier.serial;
  }

  static Future<String> encrypt(String text) async {
    return "";
  }

  static String getLat() {
    return "0.000";
  }

  static String getLong() {
    return "0.000";
  }
}

class StatusCode {
  static const success = "000";
  static const wrongPin = "091";
}

class Contacts {
  static const twitterUrl = "https://twitter.com/CentenaryBank";
  static const facebookUrl =
      "https://www.facebook.com/Centenarybank/?ref=br_rs";
  static const bankNumber = "0800200555";
  static const bankEmail = "info@centenarybank.co.ug";
  static const chatUrl =
      "https://web.powerva.microsoft.com/environments/Default-41c79b66-e60a-4ca0-896b-f4bfdf6a9678/bots/new_bot_49bd010dd726465cab846eb4cdc61ea6/webchat";
}
