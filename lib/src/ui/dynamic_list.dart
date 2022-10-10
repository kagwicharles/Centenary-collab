import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/ui/form_components/tab_layout.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';
import 'package:rafiki/src/utils/determine_render_widget.dart';

class ModulesListWidget extends StatefulWidget {
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
  State<ModulesListWidget> createState() => _ModulesListWidgetState();
}

class _ModulesListWidgetState extends State<ModulesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.moduleName)),
        body: FutureBuilder<List<ModuleItem>>(
            future: widget.moduleItems,
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
                              (widget.orientation == Orientation.portrait)
                                  ? 3
                                  : 4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          var name = snapshot.data![index].moduleName;
                          var imageUrl = snapshot.data![index].moduleUrl;
                          var moduleId = snapshot.data![index].moduleId;
                          var moduleCategory =
                              snapshot.data![index].moduleCategory;
                          var merchantID = snapshot.data![index].merchantID;

                          return ModuleItemWidget(
                            imageUrl: imageUrl!,
                            moduleName: name,
                            moduleId: moduleId,
                            parentModule: widget.parentModule,
                            moduleCategory: moduleCategory,
                            merchantID: merchantID,
                          );
                        }));
              }
              return child;
            }));
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}

class FormsListWidget extends StatefulWidget {
  final Future<List<FormItem>>? formItems;
  final orientation;
  final String parentModule;
  final String moduleName;
  String? merchantID;

  FormsListWidget(
      {required this.orientation,
      required this.formItems,
      required this.parentModule,
      required this.moduleName,
      this.merchantID});

  @override
  State<FormsListWidget> createState() => _FormsListWidgetState();
}

class _FormsListWidgetState extends State<FormsListWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    InputUtil.formInputValues.clear();
    InputUtil.encryptedField.clear();

    return FutureBuilder<List<FormItem>>(
        future: widget.formItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<FormItem>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            var filteredFormItems = snapshot.data!
                .where((formItem) => formItem.formSequence == 1)
                .toList()
              ..sort(((a, b) {
                return a.displayOrder!.compareTo(b.displayOrder!);
              }));
            child = snapshot.data!
                    .map((item) => item.controlType)
                    .contains("CONTAINER")
                ? TabWidget(
                    title: "test",
                    formItems: filteredFormItems,
                    moduleName: widget.moduleName,
                    merchantID: widget.merchantID,
                    updateState: updateState)
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
                                  return DetermineRenderWidget(controlType,
                                      formKey: _formKey,
                                      formItem: filteredFormItems[index],
                                      merchantID: widget.merchantID,
                                      refreshParent: updateState);
                                }))));
          }
          return child;
        });
  }

  void updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}
