import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';

class MainMenuWidget extends StatelessWidget {
  MainMenuWidget({Key? key}) : super(key: key);

  final List<MenuItem> mainMenuItems = [
    MenuItem(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItem(title: "Send money", icon: "assets/icons/send-money.png"),
    MenuItem(title: "Insurance", icon: "assets/icons/pay.png")
  ];

  @override
  Widget build(BuildContext context) {
    return
        // ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: mainMenuItems.length,
        //

        Swiper(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuItemWidget(
                      icon: "assets/icons/loan.png",
                      title: "Insurance",
                      color: Colors.white,
                    ),
                    MenuItemWidget(
                      icon: "assets/icons/loan.png",
                      title: "Loan",
                      color: Colors.white,
                    ),
                    MenuItemWidget(
                      icon: "assets/icons/send-money.png",
                      title: "Send",
                      color: Colors.white,
                    ),
                    MenuItemWidget(
                      icon: "assets/icons/pay.png",
                      title: "Pay",
                      color: Colors.white,
                    )
                  ]);
            });
  }
}

class SubMenuWidget extends StatelessWidget {
  SubMenuWidget({Key? key}) : super(key: key);

  final List<MenuItem> subMenuItems = [
    MenuItem(title: "Elimu Insurance", icon: "assets/icons/payment.png"),
    MenuItem(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItem(title: "Pay", icon: "assets/icons/pay.png"),
    MenuItem(title: "Send money", icon: "assets/icons/send-money.png"),
    MenuItem(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItem(title: "Pay", icon: "assets/icons/pay.png"),
    MenuItem(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItem(title: "Pay", icon: "assets/icons/pay.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: .3 / .4,
            ),
            itemCount: subMenuItems.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            MenuItemWidget(
                                icon: subMenuItems[index].icon,
                                title: subMenuItems[index].title)
                          ]))));
            }));
  }
}
