import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';

class MainMenuWidget extends StatelessWidget {
  MainMenuWidget({Key? key}) : super(key: key);

  final List<MenuItemData> mainMenuItemDatas = [
    MenuItemData(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItemData(title: "Send money", icon: "assets/icons/send-money.png"),
    MenuItemData(title: "Insurance", icon: "assets/icons/pay.png")
  ];

  @override
  Widget build(BuildContext context) {
    return
        // ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: mainMenuItemDatas.length,
        //

        Swiper(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuItemDataWidget(
                      icon: "assets/icons/loan.png",
                      title: "Insurance",
                      color: Colors.white,
                    ),
                    MenuItemDataWidget(
                      icon: "assets/icons/loan.png",
                      title: "Loan",
                      color: Colors.white,
                    ),
                    MenuItemDataWidget(
                      icon: "assets/icons/send-money.png",
                      title: "Send",
                      color: Colors.white,
                    ),
                    MenuItemDataWidget(
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

  final List<MenuItemData> subMenuItemDatas = [
    MenuItemData(title: "Elimu Insurance", icon: "assets/icons/payment.png"),
    MenuItemData(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItemData(title: "Pay", icon: "assets/icons/pay.png"),
    MenuItemData(title: "Send money", icon: "assets/icons/send-money.png"),
    MenuItemData(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItemData(title: "Pay", icon: "assets/icons/pay.png"),
    MenuItemData(title: "Elimu insurance", icon: "assets/icons/loan.png"),
    MenuItemData(title: "Pay", icon: "assets/icons/pay.png"),
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
            itemCount: subMenuItemDatas.length,
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
                            MenuItemDataWidget(
                                icon: subMenuItemDatas[index].icon,
                                title: subMenuItemDatas[index].title)
                          ]))));
            }));
  }
}
