import 'package:url_launcher/url_launcher.dart';

class CommonLibs {
  static Future<void> openUrl(Uri url) async {
    await launchUrl(url);
  }
}
