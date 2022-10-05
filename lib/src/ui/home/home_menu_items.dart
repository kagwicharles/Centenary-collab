import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/data/user_model.dart';
import 'package:rafiki/src/ui/dynamic.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';

class MainMenuWidget extends StatefulWidget {
  const MainMenuWidget({Key? key}) : super(key: key);

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  final _frequentAccessedModuleRepository = FrequentAccessedModuleRepository();
  late List<FrequentAccessedModule> favourites;

  @override
  Widget build(BuildContext context) {
    getModuleItems() =>
        _frequentAccessedModuleRepository.getAllFrequentModules();
    getModuleItems().then(
      (value) => {
        if (value.isEmpty) {setState(() {})} else {favourites = value}
      },
    );
    return FutureBuilder<List<FrequentAccessedModule>>(
        future: getModuleItems(),
        builder: (BuildContext context,
            AsyncSnapshot<List<FrequentAccessedModule>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            child = ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favourites.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DynamicWidget(
                                moduleId: favourites[index].moduleID,
                                moduleName: favourites[index].moduleName,
                                parentModule: favourites[index].parentModule,
                                moduleCategory:
                                    favourites[index].moduleCategory,
                              )));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 125,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: favourites[index].moduleUrl,
                              height: 48,
                              width: 48,
                              placeholder: (context, url) =>
                                  Lottie.asset('assets/lottie/loading.json'),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Flexible(
                                child: Text(favourites[index].moduleName,
                                    // overflow: TextOverflow.fade,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600))),
                          ]),
                    ));
              },
            );
          }
          return child;
        });
  }
}

class SubMenuWidget extends StatefulWidget {
  const SubMenuWidget({Key? key}) : super(key: key);

  @override
  State<SubMenuWidget> createState() => _SubMenuWidgetState();
}

class _SubMenuWidgetState extends State<SubMenuWidget> {
  final _moduleRepository = ModuleRepository();

  @override
  Widget build(BuildContext context) {
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
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                  child: ModuleItemWidget(
                                imageUrl: snapshot.data![index].moduleUrl!,
                                moduleName: snapshot.data![index].moduleName,
                                moduleId: snapshot.data![index].moduleId,
                                parentModule:
                                    snapshot.data![index].parentModule,
                                moduleCategory:
                                    snapshot.data![index].moduleCategory,
                                isMain: true,
                              ))));
                    }));
          }
          return child;
        });
  }
}
