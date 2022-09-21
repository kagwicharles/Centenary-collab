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
                            imageUrl: imageUrl!,
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

class FormsListWidget extends StatefulWidget {
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
  State<FormsListWidget> createState() => _FormsListWidgetState();
}

class _FormsListWidgetState extends State<FormsListWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    List<TextFormField> formWidgets = [];

    return FutureBuilder<List<FormItem>>(
        future: widget.formItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<FormItem>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            var filteredFormItems = snapshot.data!
                .where((formItem) => formItem.formSequence == 1)
                .toList();
            child = snapshot.data!
                    .map((item) => item.controlType)
                    .contains("CONTAINER")
                ? TabWidget(
                    title: "test",
                    formItems: filteredFormItems,
                    moduleName: widget.moduleName,
                    formKey: _formKey)
                : Scaffold(
                    appBar: AppBar(title: Text(widget.moduleName)),
                    body: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: Form(
                            key: _formKey,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredFormItems.length,
                                itemBuilder: (context, index) {
                                  var controlType;
                                  try {
                                    controlType = ViewType.values.byName(
                                        filteredFormItems[index].controlType!);
                                  } catch (e) {}

                                  var controlText =
                                      filteredFormItems[index].controlText;
                                  var isMandatory =
                                      filteredFormItems[index].isMandatory;

                                  print("Is mandatory: $isMandatory");
                                  return CommonUtils.determineRenderWidget(
                                      controlType,
                                      text: controlText,
                                      isMandatory: isMandatory,
                                      formKey: _formKey);
                                }))));
          }
          return child;
        });
  }
}
