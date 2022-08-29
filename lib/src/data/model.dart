import 'package:flutter/material.dart';

class CreditCard {
  final String balance;
  final String currency;

  CreditCard({
    required this.balance,
    required this.currency,
  });

  CreditCard.fromMap(Map map)
      : this(
          balance: map['balance'],
          currency: map['currency'],
        );
}

class MenuItemData {
  final String title;
  final String icon;

  MenuItemData({required this.title, required this.icon});
}

class ModuleItem {
  String parentModule;
  String moduleUrl;
  String moduleId;
  String moduleName;
  String moduleCategory;

  ModuleItem(
      {required this.parentModule,
      required this.moduleUrl,
      required this.moduleId,
      required this.moduleName,
      required this.moduleCategory});

  ModuleItem.fromJson(Map<String, dynamic> json)
      : parentModule = json["ParentModule"],
        moduleUrl = json["ModuleURL"],
        moduleId = json["ModuleID"],
        moduleName = json["ModuleName"],
        moduleCategory = json["ModuleCategory"];
}

class FormItem {
  String? controlType;
  String? controlText;
  String? moduleId;

  FormItem(
      {required this.controlType,
      required this.controlText,
      required this.moduleId});

  FormItem.fromJson(Map<String, dynamic> json) {
    controlType = json['ControlType'];
    controlText = json['ControlText'];
    moduleId = json['ModuleID'];
  }
}
