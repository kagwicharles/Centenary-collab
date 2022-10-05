// ignore_for_file: constant_identifier_names

import 'package:floor/floor.dart';

enum UserAccountData {
  FirstName,
  LastName,
  IDNumber,
  EmailID,
  ImageUrl,
  LastLoginDateTime,
  LoanLimit
}

@entity
class BankAccount {
  @primaryKey
  int? no;
  String bankAccountId;
  String aliasName;
  String currencyID;
  String accountType;
  bool groupAccount;
  bool defaultAccount;

  BankAccount(
      {required this.bankAccountId,
      this.aliasName = "",
      this.currencyID = "",
      this.accountType = "",
      required this.groupAccount,
      required this.defaultAccount});

  BankAccount.fromJson(Map<String, dynamic> json)
      : bankAccountId = json["BankAccountID"],
        aliasName = json["AliasName"],
        currencyID = json["CurrencyID"],
        accountType = json["AccountType"],
        groupAccount = json["GroupAccount"],
        defaultAccount = json["DefaultAccount"];
}

@entity
class FrequentAccessedModule {
  @primaryKey
  int? no;
  String parentModule;
  String moduleID;
  String moduleCategory;
  String moduleUrl;
  String? badgeColor;
  String? badgeText;
  String? merchantId;
  double? displayOrder;
  String? containerID;
  String? lastAccessed;

  FrequentAccessedModule(
      {required this.parentModule,
      required this.moduleID,
      required this.moduleCategory,
      required this.moduleUrl,
      required this.merchantId,
      this.badgeColor,
      this.badgeText,
      this.displayOrder,
      this.containerID,
      this.lastAccessed});

  FrequentAccessedModule.fromJson(Map<String, dynamic> json)
      : parentModule = json["ParentModule"],
        moduleID = json["ModuleID"],
        moduleCategory = json["ModuleCategory"],
        moduleUrl = json["ModuleURL"],
        badgeColor = json["BadgeColor"],
        badgeText = json["BadgeText"],
        displayOrder = json["DisplayOrder"],
        containerID = json["ContainerID"],
        lastAccessed = json["LastAccessed"];
}

@entity
class Beneficiary {
  @primaryKey
  int? no;
  String merchantID;
  String merchantName;
  String accountID;
  String accountAlias;
  String? bankID;
  String? branchID;

  Beneficiary(
      {required this.merchantID,
      required this.merchantName,
      required this.accountID,
      required this.accountAlias,
      this.bankID,
      this.branchID});

  Beneficiary.fromJson(Map<String, dynamic> json)
      : merchantID = json["MerchantID"],
        merchantName = json["MerchantName"],
        accountID = json["AccountID"],
        accountAlias = json["AccountAlias"],
        bankID = json["BankID"],
        branchID = json["BranchID"];
}

@entity
class ModuleToHide {
  @primaryKey
  int? no;
  String moduleId;

  ModuleToHide({required this.moduleId});

  ModuleToHide.fromJson(Map<String, dynamic> json)
      : moduleId = json["ModuleID"];
}

@entity
class ModuleToDisable {
  @primaryKey
  int? no;
  String moduleID;
  String? merchantID;
  String? displayMessage;

  ModuleToDisable(
      {required this.moduleID, this.merchantID, this.displayMessage});

  ModuleToDisable.fromJson(Map<String, dynamic> json)
      : moduleID = json[""],
        merchantID = json[""],
        displayMessage = json[""];
}

//TODO Add Entity for service alerts
//TODO Add Entity for loanlimit
