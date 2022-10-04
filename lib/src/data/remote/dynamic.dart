import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/data/repository/repository.dart';

class DynamicRequest {
  final _actionControlRepository = ActionControlRepository();
  final _services = TestEndpoint();

  dynamicRequest(String moduleId, String actionId, {dataObj}) {
    ActionType actionType;
    Map requestObj;
    _actionControlRepository
        .getActionControlByModuleIdAndActionId(moduleId, actionId)
        .then((actionControl) async {
      actionType = ActionType.values.byName(actionControl!.actionType);
      print("Action type...${actionControl.actionType}");

      switch (actionType) {
        case ActionType.DBCALL:
          {
            requestObj = await dbCall(
                actionType: actionType.name,
                merchantId: actionControl.merchantId,
                moduleId: moduleId,
                data: dataObj);
            TestEndpoint().dynamicRequest(
                requestObj: requestObj, webHeader: actionControl.webHeader);
          }
          break;
        case ActionType.ACTIVATIONREQ:
          // TODO: Handle this case.
          break;
        case ActionType.PAYBILL:
          // TODO: Handle this case.
          break;
        case ActionType.VALIDATE:
          {
            requestObj = await validateCall(
                actionType: actionType.name,
                merchantId: actionControl.merchantId,
                moduleId: moduleId,
                data: dataObj);
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
    requestObj["DynamicForm"] = data;
    print("Current request obj...$requestObj");
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
    print("Current request obj...$requestObj");
    return requestObj;
  }
}
