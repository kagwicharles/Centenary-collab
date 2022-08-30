import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/test/test.dart';
import 'package:rafiki/src/ui/dynamic_list.dart';

class DynamicWidget extends StatelessWidget {
  final String moduleId;
  final String moduleName;
  final String parentModule;
  final String moduleCategory;
  List<FormItem> content = [];

  Future<List<FormItem>>? _formItems;
  Future<List<ModuleItem>>? _moduleItems;

  DynamicWidget(
      {Key? key,
      required this.moduleId,
      required this.moduleName,
      required this.parentModule,
      required this.moduleCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    _formItems = DynamicData.readFormsJson(moduleId);
    _moduleItems = DynamicData.readModulesJson(moduleId);

    return moduleCategory == "FORM"
        ? FormsListWidget(
            orientation: orientation,
            formItems: _formItems,
            parentModule: parentModule,
            moduleName: moduleName,
          )
        : ModulesListWidget(
            orientation: orientation,
            moduleItems: _moduleItems,
            parentModule: parentModule,
            moduleName: moduleName);
  }
}
