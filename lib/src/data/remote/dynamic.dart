import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/data/repository/repository.dart';
import 'package:rafiki/src/ui/dynamic.dart';
import 'package:rafiki/src/ui/info/request_status.dart';
import 'package:rafiki/src/ui/list/transaction_list.dart';
import 'package:rafiki/src/utils/app_logger.dart';
import 'package:rafiki/src/utils/common_libs.dart';
import 'package:rafiki/src/utils/common_widgets.dart';

class DynamicRequest {
  Map requestObj = {};
  DynamicResponse? dynamicResponse;
  final _actionControlRepository = ActionControlRepository();
  final _services = TestEndpoint();

  Future<DynamicResponse?> dynamicRequest(String moduleId, String actionId,
      {dataObj,
      merchantID,
      moduleName,
      encryptedField,
      isList = false,
      context,
      isNotTransactionList = true}) async {
    Map requestMap = {};
    ActionType actionType;
    String? message;
    Widget? widget;
    await _services.baseRequestSetUp();
    requestObj = _services.requestObj;
    requestObj["MerchantID"] = merchantID;
    requestObj["ModuleID"] = moduleId;
    requestObj["SessionID"] = "ffffffff-e46c-53ce-0000-00001d093e12";
    await _actionControlRepository
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
            requestObj["FormID"] = actionType.name;
            if (isNotTransactionList) {
              requestMap.addAll({"HEADER": "$merchantID"});
            }
            if (isList) {
              requestMap["HEADER"] = actionId;
              requestMap["MerchantID"] = merchantID;
            }
            dbCall(data: requestMap);
            dynamicResponse = await _services.dynamicRequest(
                requestObj: requestObj, webHeader: actionControl.webHeader);
            postDynamicCallCheck(
                context: context,
                actionID: actionId,
                formID: dynamicResponse?.formID,
                merchantID: merchantID,
                moduleName: moduleName,
                status: dynamicResponse?.status,
                message: dynamicResponse?.message,
                jsonDisplay: dynamicResponse?.display,
                opensDynamicRoute:
                    dynamicResponse?.display != null ? true : false,
                isNotTransactionList: isNotTransactionList,
                list: dynamicResponse?.dynamicList,
                isList: isList);
            debugPrint("Completing dbcall...");
          }
          break;
        case ActionType.ACTIVATIONREQ:
          // TODO: Handle this case.
          break;
        case ActionType.PAYBILL:
          var notifications;
          requestObj["FormID"] = actionType.name;
          payBillCall(data: requestMap, encryptedFields: encryptedField);
          _services
              .dynamicRequest(
                  requestObj: requestObj, webHeader: actionControl.webHeader)
              .then((value) => {
                    notifications = value.notifications,
                    debugPrint("Notifications...$notifications"),
                    if (notifications != null)
                      {message = notifications[0]["NotifyText"]},
                    postDynamicCallCheck(
                        context: context,
                        actionID: actionId,
                        status: value.status,
                        message: message,
                        isNotTransactionList: isNotTransactionList)
                  });
          break;
        case ActionType.VALIDATE:
          {
            requestObj["FormID"] = actionType.name;
            validateCall(data: requestMap);
            await _services
                .dynamicRequest(
                    requestObj: requestObj, webHeader: actionControl.webHeader)
                .then((value) => {
                      debugPrint(
                          "Pre-post-dynamic call...moduleName...$moduleName"),
                      postDynamicCallCheck(
                        context: context,
                        actionID: actionId,
                        status: value.status,
                        message: value.message,
                        formID: value.formID,
                        merchantID: merchantID,
                        moduleName: moduleName,
                        jsonDisplay: value.display,
                        isNotTransactionList: isNotTransactionList,
                        nextFormSequence: value.nextFormSequence,
                        opensDynamicRoute:
                            value.formID != null && value.formID!.length > 1
                                ? true
                                : false,
                      )
                    });
          }
          break;
        case ActionType.LOGIN:
          // TODO: Handle this case.
          break;
        case ActionType.CHANGEPIN:
          // TODO: Handle this case
          break;
        case ActionType.ACTIVATE:
          // TODO: Handle this case.
          break;
        case ActionType.BENEFICIARY:
          // TODO: Handle this case.
          break;
      }
    });
    debugPrint("Returning...$widget");
    return dynamicResponse;
  }

  void navigateToStatusRoute({context, status, message}) {
    CommonLibs.navigateToRoute(
        context: context,
        widget: RequestStatusScreen(
          statusCode: status,
          message: message,
        ));
  }

  dbCall({data}) {
    requestObj["DynamicForm"] = data;
  }

  validateCall({data}) {
    requestObj["Validate"] = data;
  }

  payBillCall({data, encryptedFields}) {
    requestObj["PayBill"] = data;
    requestObj["EncryptedFields"] = encryptedFields;
  }

  postDynamicCallCheck(
      {required context,
      required actionID,
      required status,
      required message,
      formID,
      moduleName,
      merchantID,
      jsonDisplay,
      nextFormSequence,
      isNotTransactionList,
      list,
      isList = false,
      returnsWidget = false,
      opensDynamicRoute = false}) {
    EasyLoading.dismiss();
    debugPrint("Post dynamic module name...$moduleName");
    switch (status) {
      case "000":
        {
          if (opensDynamicRoute) {
            CommonLibs.navigateToRoute(
                context: context,
                widget: DynamicWidget(
                    nextFormSequence: nextFormSequence,
                    isWizard: true,
                    jsonDisplay: jsonDisplay,
                    merchantID: merchantID,
                    moduleId: formID,
                    moduleName: moduleName,
                    moduleCategory: "FORM"));
            break;
          }

          if (isNotTransactionList && isList == false) {
            showStatusScreen(
                context: context, status: status, message: message);
          } else if (isList) {
          } else {
            CommonLibs.navigateToRoute(
                context: context,
                widget: TransactionList(
                  dynamicList: list,
                  moduleName: moduleName,
                ));
          }
        }
        break;
      case "091":
        {
          showStatusScreen(context: context, status: status, message: message);
        }
        break;
      case "099":
        {
          showStatusScreen(context: context, status: status, message: message);
        }
        break;
      default:
        {
          CommonWidgets.buildNormalSnackBar(
              context: context, message: "Error processing request!");
        }
    }
  }

  showStatusScreen({required context, required status, required message}) {
    if (status != null && message != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        navigateToStatusRoute(
            context: context, status: status, message: message);
      });
    }
  }
}
