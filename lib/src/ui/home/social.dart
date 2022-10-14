import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

class SocialContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
        child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: Container(
                height: 144,
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 450),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Connect with US!",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600)),
                          Image.asset(
                            "assets/images/contact_us.png",
                            height: 70,
                            width: 70,
                          )
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GFIconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.twitter),
                          shape: GFIconButtonShape.pills,
                        ),
                        GFIconButton(
                            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                            icon: const FaIcon(FontAwesomeIcons.facebook),
                            shape: GFIconButtonShape.pills,
                            onPressed: () {
                              print("Pressed");
                            }),
                        GFIconButton(
                            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                            icon: const FaIcon(FontAwesomeIcons.phone),
                            shape: GFIconButtonShape.pills,
                            onPressed: () {
                              print("Pressed");
                            }),
                        GFIconButton(
                            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                            icon: const FaIcon(FontAwesomeIcons.message),
                            shape: GFIconButtonShape.pills,
                            onPressed: () {
                              print("Pressed");
                            }),
                        GFIconButton(
                            // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                            icon: const FaIcon(FontAwesomeIcons.comments),
                            shape: GFIconButtonShape.pills,
                            onPressed: () {
                              print("Pressed");
                            }),
                      ],
                    )
                  ],
                ))));
  }
}
