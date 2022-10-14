import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/ui/dynamic_list.dart';

class DynamicWidget extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  final String moduleCategory;
  String? parentModule;
  var jsonDisplay;
  String? merchantID;
  int? nextFormSequence;
  bool isWizard;

  DynamicWidget(
      {Key? key,
      required this.moduleId,
      required this.moduleName,
      required this.moduleCategory,
      this.jsonDisplay,
      this.parentModule,
      this.merchantID,
      this.nextFormSequence,
      this.isWizard = false})
      : super(key: key);

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  List<FormItem> content = [];
  Future<List<ModuleItem>>? _moduleItems;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    EasyLoading.dismiss();
    // _formItems = DynamicData.readFormsJson(moduleId);
    // _moduleItems = DynamicData.readModulesJson(moduleId);
    debugPrint("Module id...${widget.moduleId}");
    debugPrint("Module name...${widget.moduleName}");
    return widget.moduleCategory == "FORM"
        ? FormsListWidget(
            orientation: orientation,
            moduleName: widget.moduleName,
            moduleID: widget.moduleId,
            merchantID: widget.merchantID,
            jsonDisplay: widget.jsonDisplay,
            nextFormSequence: widget.nextFormSequence,
            isWizard: widget.isWizard)
        : ModulesListWidget(
            orientation: orientation,
            parentModule: widget.parentModule!,
            moduleName: widget.moduleName,
            moduleID: widget.moduleId,
          );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
