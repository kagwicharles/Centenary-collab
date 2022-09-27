import 'package:rafiki/src/data/local/local_db/database.dart';
import 'package:rafiki/src/data/model.dart';

class ModuleRepository {
  insertModuleItem(ModuleItem moduleItem) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final moduleItemDao = database.moduleItemDao;
    moduleItemDao.insertModuleItem(moduleItem);
  }

  Future<List<ModuleItem>> getModulesById(String id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final moduleItemDao = database.moduleItemDao;
    return moduleItemDao.getModulesById(id);
  }

  void clearTable() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final moduleItemDao = database.moduleItemDao;
    moduleItemDao.clearTable();
  }
}

class FormsRepository {
  void insertFormItem(FormItem formItem) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final moduleItemDao = database.formItemDao;
    moduleItemDao.insertFormItem(formItem);
  }

  Future<List<FormItem>> getFormsByModuleId(String id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final formItemDao = database.formItemDao;
    return formItemDao.getFormsByModuleId(id);
  }

  void clearTable() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final formItemDao = database.formItemDao;
    formItemDao.clearTable();
  }
}

class ActionControlRepository {
  void insertActionControl(ActionItem actionItem) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final actionControlDao = database.actionControlDao;
    actionControlDao.insertActionControl(actionItem);
  }

  Future<ActionItem?> getActionControlByModuleIdAndActionId(
      String moduleId, actionId) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final actionControlDao = database.actionControlDao;
    return actionControlDao.getActionControlByModuleIdAndActionId(
        moduleId, actionId);
  }

  void clearTable() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final actionControlDao = database.actionControlDao;
    actionControlDao.clearTable();
  }
}
