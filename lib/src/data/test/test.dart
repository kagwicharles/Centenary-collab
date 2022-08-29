import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rafiki/src/data/model.dart';

class DynamicData {
  static Future<List<ModuleItem>> readModulesJson(String parentModule) async {
    List<ModuleItem> modules = [];
    final String response =
        await rootBundle.loadString('assets/json/modules.json');
    final data = await json.decode(response);
    data[0]["Modules"].forEach((item) {
      if (ModuleItem.fromJson(item).parentModule == parentModule) {
        modules.add(ModuleItem.fromJson(item));
      }
    });
    return modules;
  }

  static Future<List<FormItem>> readFormsJson(String moduleId) async {
    List<FormItem> forms = [];
    final String response =
        await rootBundle.loadString('assets/json/forms.json');
    final data = await json.decode(response);
    data[0]["FormControls"].forEach((item) {
      if (FormItem.fromJson(item).moduleId == moduleId) {
        forms.add(FormItem.fromJson(item));
      }
    });
    return forms;
  }
}