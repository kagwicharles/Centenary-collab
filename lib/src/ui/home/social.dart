import 'package:flutter/material.dart';
import 'package:rafiki/src/data/constants.dart';
import 'package:rafiki/src/utils/common_libs.dart';

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
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Connect with US!",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        CommonLibs.openUrl(
                                            Uri.parse(Contacts.twitterUrl));
                                      },
                                      child: Image.asset(
                                        "assets/icons/twitter.png",
                                        height: 34,
                                        width: 44,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CommonLibs.openUrl(
                                            Uri.parse(Contacts.facebookUrl));
                                      },
                                      child: Image.asset(
                                        "assets/icons/facebook.png",
                                        height: 34,
                                        width: 44,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CommonLibs.openUrl(Uri.parse(
                                            "tel://${Contacts.bankNumber}"));
                                      },
                                      child: Image.asset(
                                        "assets/icons/telephone.png",
                                        height: 34,
                                        width: 44,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CommonLibs.openUrl(Uri.parse(
                                            "mailto://${Contacts.bankEmail}"));
                                      },
                                      child: Image.asset(
                                        "assets/icons/email.png",
                                        height: 34,
                                        width: 44,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        CommonLibs.openUrl(Uri.parse(
                                            "sms:${Contacts.chatUrl}"));
                                      },
                                      child: Image.asset(
                                        "assets/icons/chat.png",
                                        height: 34,
                                        width: 34,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    Image.asset(
                      "assets/images/contact_us.png",
                    )
                  ],
                ))));
  }
}
