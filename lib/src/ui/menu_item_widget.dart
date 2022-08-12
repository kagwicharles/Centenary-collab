import 'package:flutter/material.dart';

class MenuItemDataWidget extends StatelessWidget {
  MenuItemDataWidget(
      {Key? key,
      required this.icon,
      required this.title,
      this.color = Colors.black})
      : super(key: key);

  final String icon;
  final String title;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Container(
          width: 85,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: 40,
                height: 40,
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                title,
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}
