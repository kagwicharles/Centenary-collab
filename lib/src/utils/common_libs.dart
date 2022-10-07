import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonLibs {
  static Future<void> openUrl(Uri url) async {
    await launchUrl(url);
  }

  static navigateToRoute({required context, required widget}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}
