import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/ui/form_components/form_widgets.dart';
import 'package:rafiki/src/ui/form_components/tab_layout.dart';
import 'package:rafiki/src/ui/menu_item_widget.dart';
import 'package:rafiki/src/utils/determine_render_widget.dart';

class ModulesListWidget extends StatefulWidget {
  final orientation;
  final String parentModule;
  final String moduleName;
  final String moduleID;

  ModulesListWidget(
      {required this.orientation,
      required this.parentModule,
      required this.moduleName,
      required this.moduleID});

  @override
  State<ModulesListWidget> createState() => _ModulesListWidgetState();
}

class _ModulesListWidgetState extends State<ModulesListWidget> {
  final _moduleRepository = ModuleRepository();

  getModules() => _moduleRepository.getModulesById(widget.moduleID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.moduleName)),
        body: FutureBuilder<List<ModuleItem>>(
            future: getModules(),
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
  final orientation;
  final String moduleName;
  final String moduleID;
  String? merchantID;
  var jsonDisplay;
  int? nextFormSequence;

  FormsListWidget(
      {Key? key,
      required this.orientation,
      required this.moduleName,
      required this.moduleID,
      this.merchantID,
      this.jsonDisplay,
      this.nextFormSequence})
      : super(key: key);

  @override
  State<FormsListWidget> createState() => _FormsListWidgetState();
}

class _FormsListWidgetState extends State<FormsListWidget> {
  int? currentForm;
  final _formKey = GlobalKey<FormState>();
  final _formsRepository = FormsRepository();

  getFormItems() => _formsRepository.getFormsByModuleId(widget.moduleID);

  @override
  Widget build(BuildContext context) {
    InputUtil.formInputValues.clear();
    InputUtil.encryptedField.clear();
    debugPrint(
        "Am back to forms####...showing forms from moduleID...${widget.moduleID}");

    return FutureBuilder<List<FormItem>>(
        future: getFormItems(),
        builder:
            (BuildContext context, AsyncSnapshot<List<FormItem>> snapshot) {
          Widget child = const SizedBox();
          if (snapshot.hasData) {
            if (widget.nextFormSequence != null) {
              if (widget.nextFormSequence == 0) {
                currentForm = 2;
              } else {
                currentForm = widget.nextFormSequence;
              }
            }
            var filteredFormItems = snapshot.data!
                .where(
                    (formItem) => formItem.formSequence == (currentForm ?? 1))
                .toList()
              ..sort(((a, b) {
                return a.displayOrder!.compareTo(b.displayOrder!);
              }));
            debugPrint("Filtered form items at 0...$filteredFormItems");
            child = snapshot.data!
                    .map((item) => item.controlType)
                    .contains("CONTAINER")
                ? TabWidget(
                    title: "test",
                    formItems: filteredFormItems,
                    moduleName: widget.moduleName,
                    merchantID: widget.merchantID,
                  )
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
                                      moduleName: widget.moduleName,
                                      jsonTxt: widget.jsonDisplay);
                                }))));
          }
          return child;
        });
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }
}
