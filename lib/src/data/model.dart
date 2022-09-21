// ignore_for_file: constant_identifier_names

import 'package:floor/floor.dart';

enum ViewType {
  TEXT,
  BUTTON,
  RBUTTON,
  DROPDOWN,
  TAB,
  LABEL,
  QRSCANNER,
  PHONECONTACTS
}

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

@entity
class ModuleItem {
  @primaryKey
  String moduleId;
  String parentModule;
  String? moduleUrl;
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

@entity
class FormItem {
  @primaryKey
  int? no;
  String? controlType;
  String? controlText;
  String? moduleId;
  String? controlId;
  String? linkedToControl;
  int? formSequence;
  String? serviceParamId;
  bool? isMandatory;
  bool? isEncrypted;

  FormItem(
      {required this.controlType,
      required this.controlText,
      required this.moduleId,
      this.linkedToControl,
      this.controlId,
      this.formSequence,
      this.isMandatory,
      this.isEncrypted,
      this.serviceParamId});

  FormItem.fromJson(Map<String, dynamic> json) {
    controlType = json['ControlType'];
    controlText = json['ControlText'];
    moduleId = json['ModuleID'];
    linkedToControl = json['LinkedToControl'];
    controlId = json['ControlID'];
    formSequence = json['FormSequence'];
    isMandatory = json['IsMandatory'];
    isEncrypted = json['IsEncrypted'];
    serviceParamId = json['ServiceParamID'];
  }
}

@entity
class ActionItem {
  @primaryKey
  int? no;
  String moduleId;
  String formId;
  String? actionType;
  String actionId;
  String serviceParamsIds;
  String controlId;

  ActionItem(
      {required this.formId,
      required this.actionType,
      required this.moduleId,
      required this.actionId,
      required this.serviceParamsIds,
      required this.controlId});

  ActionItem.fromJson(Map<String, dynamic> json)
      : formId = json["FormID"],
        actionType = json["ActionType"],
        moduleId = json["ModuleID"],
        actionId = json["ActionID"],
        serviceParamsIds = json["ServiceParamIDs"],
        controlId = json["ControlID"];
}

class FavouriteItem {
  String imageUrl;
  String title;

  FavouriteItem({required this.imageUrl, required this.title});
}
