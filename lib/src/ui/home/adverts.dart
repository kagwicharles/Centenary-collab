import 'package:flutter/material.dart';

class AdvertWidget extends StatelessWidget {
  const AdvertWidget({Key? key, required this.adResource}) : super(key: key);

  final String adResource;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              adResource,
              fit: BoxFit.fill,
            )));
  }
}
