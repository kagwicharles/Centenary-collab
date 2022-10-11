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
  final _actionControlRepository = ActionControlRepository();
  final _services = TestEndpoint();
  Map requestObj = {};

  Future<Widget?> dynamicRequest(String moduleId, String actionId,
      {dataObj, merchantID, moduleName, encryptedField, context}) async {
    ActionType actionType;
    Map requestMap = {};
    String? status, message;
    Widget? widget;
    await _services.baseRequestSetUp();
    requestObj = _services.requestObj;
    requestObj["MerchantID"] = merchantID;
    requestObj["ModuleID"] = moduleId;
    requestObj["SessionID"] = "ffffffff-e46c-53ce-0000-00001d093e12";

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
            requestObj["FormID"] = actionType.name;
            await dbCall(data: requestMap);
            await _services
                .dynamicRequest(
                    requestObj: requestObj, webHeader: actionControl.webHeader)
                .then((value) => {
                      status = value["Status"],
                      message = value["Message"],
                      widget = postDynamicCallCheck(
                          context: context,
                          actionID: actionId,
                          status: status,
                          message: message),
                      debugPrint("My Widget#$widget")
                    });
          }
          break;
        case ActionType.ACTIVATIONREQ:
          // TODO: Handle this case.
          break;
        case ActionType.PAYBILL:
          requestObj["FormID"] = actionType.name;
          payBillCall(data: requestMap, encryptedFields: encryptedField);
          _services
              .dynamicRequest(
                  requestObj: requestObj, webHeader: actionControl.webHeader)
              .then((value) => {
                    status = value["Status"],
                    message = value["Message"],
                    postDynamicCallCheck(
                        context: context,
                        actionID: actionId,
                        status: status,
                        message: message)
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
                      status = value["Status"],
                      message = value["Message"],
                      postDynamicCallCheck(
                          context: context,
                          actionID: actionId,
                          status: status,
                          message: message)
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
    return widget;
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

  Widget postDynamicCallCheck(
      {required context,
      required actionID,
      required status,
      required message,
      formID,
      moduleName,
      returnsWidget = false,
      opensDynamicRoute = false}) {
    EasyLoading.dismiss();

    switch (status) {
      case "000":
        {
          if (returnsWidget) {
            return dbCallTypeCheck(actionID, context: context);
          }
          if (opensDynamicRoute) {
            CommonLibs.navigateToRoute(
                context: context,
                widget: DynamicWidget(
                    moduleId: formID,
                    moduleName: moduleName,
                    moduleCategory: "FORM"));
            break;
          }
          showStatusScreen(context: context, status: status, message: message);
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
    return const SizedBox();
  }

  showStatusScreen({required context, required status, required message}) {
    if (status != null && message != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        navigateToStatusRoute(
            context: context, status: status, message: message);
      });
    }
  }

  Widget dbCallTypeCheck(String actionID, {required context}) {
    var enumActionID = ActionID.values.byName(actionID);
    switch (enumActionID) {
      case ActionID.GETTRXLIST:
        {
          return TransactionList();
        }
    }
  }
}
