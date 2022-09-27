import 'package:rafiki/src/data/remote/services.dart';
import 'package:rafiki/src/data/repository/repository.dart';

class DynamicRequest {
  final _actionControlRepository = ActionControlRepository();

  dynamicRequest(String moduleId, String actionId, {dataObj}) {
    _actionControlRepository
        .getActionControlByModuleIdAndActionId(moduleId, actionId)
        .then((actionControl) => {
              TestEndpoint().dynamicRequest(moduleId,
                  merchantId: actionControl?.merchantId,
                  moduleId: moduleId,
                  data: dataObj,
                  webHeader: actionControl?.webHeader)
            });
  }
}
