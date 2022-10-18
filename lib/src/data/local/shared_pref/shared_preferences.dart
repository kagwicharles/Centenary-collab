import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefLocal {
  getSharedPrefInstance() async => await SharedPreferences.getInstance();

  static addDeviceData(String token, String device, String iv) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.setString('token', token);
    await prefs.setString('device', device);
    await prefs.setString('iv', iv);
  }

  static addRoutes(Map routesMap) async {
    final prefs = await SharedPreferences.getInstance();
    routesMap.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  addStaticDataVersion(int version) {
    getSharedPrefInstance().then((sharedPref) {
      sharedPref.setInt("currentDataVersion", version);
    });
  }

  addActivationData(String mobileNumber, String customerID) {
    getSharedPrefInstance().then((sharedPref) {
      debugPrint("Setting activation data... $mobileNumber###$customerID");
      sharedPref.setString("customerMobile", mobileNumber);
      sharedPref.setString("customerID", customerID);
    });
  }

  getStaticDataVersion() async {
    final prefs = await SharedPreferences.getInstance();
    int? version = prefs.getInt("currentDataVersion");
    if (version == null) {
      return 0;
    }
    return version;
  }

  addAppIdleTimeout(int appIdleTimeout) {
    getSharedPrefInstance().then((sharedPref) {
      sharedPref.setInt("appIdleTimeout", appIdleTimeout);
    });
  }

  getAppIdleTimeout() {
    return getSharedPrefInstance().then((sharedPref) {
      sharedPref.getString("appIdleTimeout");
    });
  }

  addUserAccountData({required key, required value}) {
    getSharedPrefInstance().then((sharedPref) {
      sharedPref.setString(key, value);
    });
  }

  getCustomerMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("customerMobile");
  }

  getCustomerID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("customerID");
  }

  String getUserData({sharedPref, key}) {
    String value = "";
    value = sharedPref.getString(key);
    return value;
  }

  static getLocalToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static getLocalDevice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("device");
  }

  static getLocalIv() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("iv");
  }

  static getRoute(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(routeName);
  }
}
