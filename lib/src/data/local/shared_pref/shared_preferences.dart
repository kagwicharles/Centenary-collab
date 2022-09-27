import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefLocal {
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
