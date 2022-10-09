import 'package:flutter/material.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/utils/app_logger.dart';

class DynamicRequest {
  final _actionControlRepository = ActionControlRepository();
  final _services = TestEndpoint();

  dynamicRequest(String moduleId, String actionId,
      {dataObj, merchantID, encryptedField}) {
    ActionType actionType;
    Map requestObj;
    Map requestMap = {};
    _actionControlRepository
        .getActionControlByModuleIdAndActionId(moduleId, actionId)
        .then((actionControl) async {
      actionType = ActionType.values.byName(actionControl!.actionType);
      debugPrint("List of form values...$dataObj");
      try {
        dataObj.forEach((item) {
          requestMap.addAll(item);
          debugPrint(item.toString());
        });
      } catch (e) {
        AppLogger.appLogE(tag: "Error", message: e.toString());
      }

      switch (actionType) {
        case ActionType.DBCALL:
          {
            requestObj = await dbCall(
                actionType: actionType.name,
                merchantId: merchantID,
                moduleId: moduleId,
                data: requestMap);
            TestEndpoint().dynamicRequest(
                requestObj: requestObj, webHeader: actionControl.webHeader);
          }
          break;
        case ActionType.ACTIVATIONREQ:
          // TODO: Handle this case.
          break;
        case ActionType.PAYBILL:
          requestObj = await payBillCall(
              actionType: actionType.name,
              merchantId: merchantID,
              moduleId: moduleId,
              data: requestMap,
              encryptedFields: encryptedField);
          TestEndpoint().dynamicRequest(
              requestObj: requestObj, webHeader: actionControl.webHeader);
          break;
        case ActionType.VALIDATE:
          {
            requestObj = await validateCall(
                actionType: actionType.name,
                merchantId: merchantID,
                moduleId: moduleId,
                data: requestMap);
            TestEndpoint().dynamicRequest(
                requestObj: requestObj, webHeader: actionControl.webHeader);
          }
          break;
        case ActionType.LOGIN:
          // TODO: Handle this case.
          break;
        case ActionType.CHANGEPIN:
          // TODO: Handle this case.
          break;
        case ActionType.ACTIVATE:
          // TODO: Handle this case.
          break;
        case ActionType.BENEFICIARY:
          // TODO: Handle this case.
          break;
      }
    });
  }

  Future<Map<String, dynamic>> dbCall(
      {actionType, merchantId, moduleId, data}) async {
    await _services.baseRequestSetUp();
    var requestObj = _services.requestObj;
    requestObj["FormID"] = actionType;
    requestObj["MerchantID"] = merchantId;
    requestObj["ModuleID"] = moduleId;
    requestObj["SessionID"] = "00000000-13f7-a5b8-0000-00001d093e12";
    requestObj["DynamicForm"] = data;
    return requestObj;
  }

  Future<Map<String, dynamic>> validateCall(
      {actionType, merchantId, moduleId, data}) async {
    await _services.baseRequestSetUp();
    var requestObj = _services.requestObj;
    requestObj["FormID"] = actionType;
    requestObj["MerchantID"] = merchantId;
    requestObj["ModuleID"] = moduleId;
    requestObj["Validate"] = data;
    return requestObj;
  }

  Future<Map<String, dynamic>> payBillCall(
      {actionType, merchantId, moduleId, data, encryptedFields}) async {
    await _services.baseRequestSetUp();
    var requestObj = _services.requestObj;
    requestObj["FormID"] = actionType;
    requestObj["MerchantID"] = merchantId;
    requestObj["ModuleID"] = moduleId;
    requestObj["SessionID"] = "ffffffff-e46c-53ce-0000-00001d093e12";
    requestObj["PayBill"] = data;
    requestObj["EncryptedFields"] = encryptedFields;
    return requestObj;
  }
}
