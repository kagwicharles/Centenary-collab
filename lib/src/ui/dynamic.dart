import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/ui/dynamic_list.dart';

class DynamicWidget extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  String? parentModule;
  final String moduleCategory;
  String? merchantID;

  DynamicWidget(
      {Key? key,
      required this.moduleId,
      required this.moduleName,
      this.parentModule,
      required this.moduleCategory,
      this.merchantID})
      : super(key: key);

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  List<FormItem> content = [];

  final _moduleRepository = ModuleRepository();

  Future<List<ModuleItem>>? _moduleItems;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    EasyLoading.dismiss();
    // _formItems = DynamicData.readFormsJson(moduleId);
    // _moduleItems = DynamicData.readModulesJson(moduleId);

    _moduleItems = _moduleRepository.getModulesById(widget.moduleId);

    return widget.moduleCategory == "FORM"
        ? FormsListWidget(
            orientation: orientation,
            moduleName: widget.moduleName,
            moduleID: widget.moduleId,
            merchantID: widget.merchantID)
        : ModulesListWidget(
            orientation: orientation,
            moduleItems: _moduleItems,
            parentModule: widget.parentModule!,
            moduleName: widget.moduleName);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
