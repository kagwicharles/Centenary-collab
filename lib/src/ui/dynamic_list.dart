import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/ui/form_components/tab_layout.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';
import 'package:rafiki/src/utils/utils.dart';

class ModulesListWidget extends StatelessWidget {
  final Future<List<ModuleItem>>? moduleItems;
  final orientation;
  final String parentModule;
  final String moduleName;
  ModulesListWidget(
      {required this.orientation,
      required this.moduleItems,
      required this.parentModule,
      required this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(moduleName)),
        body: FutureBuilder<List<ModuleItem>>(
            future: moduleItems,
            builder: (BuildContext context,
                AsyncSnapshot<List<ModuleItem>> snapshot) {
              Widget child = const Text("Please wait...");
              if (snapshot.hasData) {
                child = Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 3 : 4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          var name = snapshot.data![index].moduleName;
                          var imageUrl = snapshot.data![index].moduleUrl;
                          var moduleId = snapshot.data![index].moduleId;
                          var moduleCategory =
                              snapshot.data![index].moduleCategory;

                          return ModuleItemWidget(
                            imageUrl: imageUrl,
                            moduleName: name,
                            moduleId: moduleId,
                            parentModule: parentModule,
                            moduleCategory: moduleCategory,
                          );
                        }));
              }
              return child;
            }));
  }
}

class FormsListWidget extends StatelessWidget {
  final Future<List<FormItem>>? formItems;
  final orientation;
  final String parentModule;
  final String moduleName;

  FormsListWidget(
      {required this.orientation,
      required this.formItems,
      required this.parentModule,
      required this.moduleName});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<FormItem>>(
        future: formItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<FormItem>> snapshot) {
          Widget child = const Text("Please wait...");
          if (snapshot.hasData) {
            child = snapshot.data!
                    .map((item) => item.controlType)
                    .contains("CONTAINER")
                ? Container(
                    height: 300,
                    child: TabWidget(
                      title: "test",
                      formItems: snapshot.data!,
                      moduleName: moduleName,
                    ))
                : Scaffold(
                    appBar: AppBar(title: Text(moduleName)),
                    body:  Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            child: ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  var controlType;
                                  try {
                                    controlType = ViewType.values.byName(
                                        snapshot.data![index].controlType!);
                                  } catch (e) {}

                                  var controlText =
                                      snapshot.data![index].controlText;

                                  return Column(children: [
                                    CommonUtils.determineRenderWidget(
                                        controlType,
                                        text: controlText),
                                    const SizedBox(height: 24)
                                  ]);
                                })));
          }
          return child;
        });
  }
}
