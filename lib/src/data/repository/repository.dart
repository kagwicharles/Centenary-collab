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

class UserCodeRepository {
  void insertUserCode(UserCode userCode) async {
    await AppDatabase.getDatabaseInstance().then((database) {
      database.userCodeDao.insertUserCode(userCode);
    });
  }

  Future<List<UserCode>> getUserCodesById(String id) async {
    return AppDatabase.getDatabaseInstance().then((database) {
      database.userCodeDao.getFormsByModuleId(id);
    });
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.userCodeDao.clearTable();
    });
  }
}

class OnlineAccountProductRepository {
  void insertOnlineAccountProduct(
      OnlineAccountProduct onlineAccountProduct) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.onlineAccountProductDao
          .insertOnlineAccountProduct(onlineAccountProduct);
    });
  }

  Future<List<OnlineAccountProduct>> getAllOnlineAccountProducts() async {
    var onlineAccountProducts;
    await AppDatabase.getDatabaseInstance().then((database) {
      onlineAccountProducts =
          database.onlineAccountProductDao.getAllOnlineAccountProducts();
    });
    return onlineAccountProducts;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.onlineAccountProductDao.clearTable();
    });
  }
}

class BankBranchRepository {
  void insertBankBranch(BankBranch bankBranch) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.bankBranchDao.insertBankBranch(bankBranch);
    });
  }

  Future<List<BankBranch>> getAllBankBranches() async {
    return AppDatabase.getDatabaseInstance().then((database) {
      database.bankBranchDao.getAllBankBranches();
    });
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.bankBranchDao.clearTable();
    });
  }
}

class ImageDataRepository {
  void insertImageData(ImageData imageData) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.imageDataDao.insertImage(imageData);
    });
  }

  Future<List<ImageData>> getAllImages(String imageType) async {
    var Images;

    await AppDatabase.getDatabaseInstance().then((database) {
      Images = database.imageDataDao.getAllImages(imageType);
    });
    return Images;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.imageDataDao.clearTable();
    });
  }
}
