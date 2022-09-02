import 'package:rafiki/src/data/local/local_db/database.dart';
import 'package:rafiki/src/data/model.dart';

class ModuleRepository {
  static var database;
  init() {
    database = AppDatabase.buildDb();
  }

  static insertModuleItem(ModuleItem moduleItem) {
    final moduleItemDao = database.moduleItemDao;
    moduleItemDao.insertModuleItem(moduleItem);
  }
}
