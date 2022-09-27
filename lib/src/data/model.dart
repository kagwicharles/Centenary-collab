// ignore_for_file: constant_identifier_names

import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

enum ViewType {
  TEXT,
  BUTTON,
  RBUTTON,
  DROPDOWN,
  TAB,
  LABEL,
  QRSCANNER,
  PHONECONTACTS,
  DATE
}

enum ControlFormat { PinNumber, PIN, NUMERIC, Amount, DATE }

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
  String? actionId;
  String? linkedToControl;
  int? formSequence;
  String? serviceParamId;
  double? displayOrder;
  String? controlFormat;
  bool? isMandatory;
  bool? isEncrypted;

  FormItem({
    required this.controlType,
    required this.controlText,
    required this.moduleId,
    this.linkedToControl,
    this.controlId,
    this.actionId,
    this.formSequence,
    this.serviceParamId,
    this.displayOrder,
    this.controlFormat,
    this.isMandatory,
    this.isEncrypted,
  });

  FormItem.fromJson(Map<String, dynamic> json) {
    controlType = json['ControlType'];
    controlText = json['ControlText'];
    moduleId = json['ModuleID'];
    linkedToControl = json['LinkedToControl'];
    controlId = json['ControlID'];
    actionId = json['ActionID'];
    formSequence = json['FormSequence'];
    serviceParamId = json['ServiceParamID'];
    displayOrder = json['DisplayOrder'];
    isMandatory = json['IsMandatory'];
    isEncrypted = json['IsEncrypted'];
    controlFormat = json['ControlFormat'];
  }
}

@entity
class ActionItem {
  @primaryKey
  int? no;
  String moduleId;
  String actionType;
  String actionId;
  String serviceParamsIds;
  String controlId;
  String webHeader;
  String? merchantId;
  String? formId;

  ActionItem(
      {required this.moduleId,
      required this.actionType,
      required this.actionId,
      required this.serviceParamsIds,
      required this.controlId,
      required this.webHeader,
      this.formId,
      this.merchantId});

  ActionItem.fromJson(Map<String, dynamic> json)
      : moduleId = json["ModuleID"],
        actionType = json["ActionType"],
        actionId = json["ActionID"],
        serviceParamsIds = json["ServiceParamIDs"],
        controlId = json["ControlID"],
        webHeader = json["WebHeader"],
        formId = json["FormID"],
        merchantId = json["MerchantID"];
}

@entity
class UserCode {
  @primaryKey
  int? no;
  String id;
  String subCodeId;
  String? description;
  String? relationId;
  String? extraField;
  double? displayOrder;
  bool? isDefault;
  String? extraFieldName;

  UserCode(
      {required this.id,
      required this.subCodeId,
      this.description,
      this.relationId,
      this.extraField,
      this.displayOrder,
      this.isDefault,
      this.extraFieldName});

  UserCode.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        subCodeId = json["SubCodeID"],
        description = json["Description"],
        relationId = json["RelationID"],
        extraField = json["ExtraField"],
        displayOrder = json["DisplayOrder"],
        isDefault = json["IsDefault"],
        extraFieldName = json["ExtraFieldName"];
}

@entity
class OnlineAccountProduct {
  @primaryKey
  int? no;
  String? id;
  String? description;
  String? relationId;
  String? url;

  OnlineAccountProduct({this.id, this.description, this.relationId, this.url});

  OnlineAccountProduct.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        description = json["Description"],
        relationId = json["RelationID"],
        url = json["Urls"];
}

@entity
class BankBranch {
  @primaryKey
  int? no;
  String? description;
  String? relationId;

  BankBranch({this.description, this.relationId});

  BankBranch.fromJson(Map<String, dynamic> json)
      : description = json["Description"],
        relationId = json["RelationID"];
}

class FavouriteItem {
  String imageUrl;
  String title;

  FavouriteItem({required this.imageUrl, required this.title});
}
