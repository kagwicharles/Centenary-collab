import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/data/test/test.dart';
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
                  children: const [
                    // MenuItemDataWidget(
                    //   icon: "assets/icons/loan.png",
                    //   title: "Insurance",
                    //   color: Colors.white,
                    // ),
                    // MenuItemDataWidget(
                    //   icon: "assets/icons/loan.png",
                    //   title: "Loan",
                    //   color: Colors.white,
                    // ),
                    // MenuItemDataWidget(
                    //   icon: "assets/icons/send-money.png",
                    //   title: "Send",
                    //   color: Colors.white,
                    // ),
                    // MenuItemDataWidget(
                    //   icon: "assets/icons/pay.png",
                    //   title: "Pay",
                    //   color: Colors.white,
                    // )
                    Text(
                      "No favourites yet!",
                      style: TextStyle(color: Colors.white),
                    )
                  ]);
            });
  }
}

class SubMenuWidget extends StatelessWidget {
  SubMenuWidget({Key? key}) : super(key: key);

  Stream<List<ModuleItem>>? _moduleItems;
  final _moduleRepository = ModuleRepository();

  @override
  Widget build(BuildContext context) {
    // _moduleItems = DynamicData.readModulesJson("MAIN");
    // _moduleItems =
    //     _moduleRepository.getModulesById("MAIN") as Stream<List<ModuleItem>>;

    return FutureBuilder<List<ModuleItem>>(
        future: _moduleRepository.getModulesById("MAIN"),
        builder:
            (BuildContext context, AsyncSnapshot<List<ModuleItem>> snapshot) {
          Widget child = const Center(child: Text("Please wait..."));
          if (snapshot.hasData) {
            child = Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: ModuleItemWidget(
                                      imageUrl:
                                          snapshot.data![index].moduleUrl!,
                                      moduleName:
                                          snapshot.data![index].moduleName,
                                      moduleId: snapshot.data![index].moduleId,
                                      parentModule:
                                          snapshot.data![index].parentModule,
                                      moduleCategory: snapshot
                                          .data![index].moduleCategory))));
                    }));
          }
          return child;
        });
  }
}
