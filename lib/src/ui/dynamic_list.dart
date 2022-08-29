import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';

class ModulesListWidget extends StatelessWidget {
  final Future<List<ModuleItem>>? moduleItems;
  final orientation;
  final String parentModule;

  ModulesListWidget(
      {required this.orientation,
      required this.moduleItems,
      required this.parentModule});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ModuleItem>>(
        future: moduleItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<ModuleItem>> snapshot) {
          Widget child = const Text("Please wait...");
          if (snapshot.hasData) {
            child = GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var name = snapshot.data![index].moduleName;
                  var imageUrl = snapshot.data![index].moduleUrl;
                  var moduleId = snapshot.data![index].moduleId;
                  var moduleCategory = snapshot.data![index].moduleCategory;

                  return ModuleItemWidget(
                    imageUrl: imageUrl,
                    moduleName: name,
                    moduleId: moduleId,
                    parentModule: parentModule,
                    moduleCategory: moduleCategory,
                  );
                });
          }
          return child;
        });
  }
}

class FormsListWidget extends StatelessWidget {
  final Future<List<FormItem>>? formItems;
  final orientation;
  final String parentModule;

  FormsListWidget(
      {required this.orientation,
      required this.formItems,
      required this.parentModule});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FormItem>>(
        future: formItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<FormItem>> snapshot) {
          Widget child = const Text("Please wait...");
          if (snapshot.hasData) {
            child = ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var controlType = snapshot.data![index].controlType;
                  var controlText = snapshot.data![index].controlText;

                  return Column(children: [
                    determineRenderWidget(controlType!, text: controlText),
                    const SizedBox(height: 24)
                  ]);
                });
          }
          return child;
        });
  }

  Widget determineRenderWidget(String widgetType, {text}) {
    String? selectedItem;
    
    switch (widgetType) {
      case "TEXT":
        {
          return TextInputWidget(text: text);
        }
      case "BUTTON":
        {
          return ButtonWidget(text: text);
        }
      case "DROPDOWN":
        {
          return DropdownButtonWidget(text: text, selectedItem: selectedItem);
        }
    }
    return const SizedBox();
  }
}
