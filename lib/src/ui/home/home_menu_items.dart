import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/data/test/test.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';

class MainMenuWidget extends StatelessWidget {
  MainMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FavouriteItem> favouriteItems = [
      FavouriteItem(
          title: "Elimu insurance", imageUrl: "assets/icons/loan.png"),
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: favouriteItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  favouriteItems[index].imageUrl,
                  height: 44,
                  width: 44,
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                    child: Text(favouriteItems[index].title,
                        // overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12))),
              ]),
        );
      },
    );
  }
}

class SubMenuWidget extends StatefulWidget {
  SubMenuWidget({Key? key}) : super(key: key);

  @override
  State<SubMenuWidget> createState() => _SubMenuWidgetState();
}

class _SubMenuWidgetState extends State<SubMenuWidget> {
  final _moduleRepository = ModuleRepository();

  @override
  Widget build(BuildContext context) {
    // _moduleItems = DynamicData.readModulesJson("MAIN");
    // _moduleItems =
    //     _moduleRepository.getModulesById("MAIN") as Stream<List<ModuleItem>>;

    getModuleItems() => _moduleRepository.getModulesById("MAIN");
    getModuleItems().then(
      (value) => {
        if (value.isEmpty) {setState(() {})}
      },
    );
    return FutureBuilder<List<ModuleItem>>(
        future: getModuleItems(),
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
