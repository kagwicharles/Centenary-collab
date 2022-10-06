import 'package:rafiki/src/data/local/local_db/database.dart';
import 'package:rafiki/src/data/model.dart';
import 'package:rafiki/src/data/user_model.dart';

class ModuleRepository {
  void insertModuleItem(ModuleItem moduleItem) async {
    await AppDatabase.getDatabaseInstance().then((database) {
      database.moduleItemDao.insertModuleItem(moduleItem);
    });
  }

  Future<List<ModuleItem>> getModulesById(String id) async {
    var modules;
    await AppDatabase.getDatabaseInstance().then((database) {
      modules = database.moduleItemDao.getModulesById(id);
    });
    return modules;
  }

  void clearTable() async {
    await AppDatabase.getDatabaseInstance().then((database) {
      database.moduleItemDao.clearTable();
    });
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

  Future<List<UserCode>> getUserCodesById(String? id) async {
    var _userCodes;
    await AppDatabase.getDatabaseInstance().then((database) {
      _userCodes = database.userCodeDao.getUserCodesById(id);
      print("Usercodes....$_userCodes");
    });
    return _userCodes;
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

class BankAccountRepository {
  void insertBankAccount(BankAccount bankAccount) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.bankAccountDao.insertBankAccount(bankAccount);
    });
  }

  Future<List<BankAccount>> getAllBankAccounts() async {
    var bankAccounts;

    await AppDatabase.getDatabaseInstance().then((database) {
      bankAccounts = database.bankAccountDao.getAllBankAccounts();
    });
    return bankAccounts;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.bankAccountDao.clearTable();
    });
  }
}

class FrequentAccessedModuleRepository {
  void insertFrequentModule(
      FrequentAccessedModule frequentAccessedModule) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.frequentAccessedModuleDao
          .insertFrequentModule(frequentAccessedModule);
    });
  }

  Future<List<FrequentAccessedModule>> getAllFrequentModules() async {
    var frequentAccessedModules;
    await AppDatabase.getDatabaseInstance().then((database) {
      frequentAccessedModules =
          database.frequentAccessedModuleDao.getAllFrequentModules();
    });
    return frequentAccessedModules;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.frequentAccessedModuleDao.clearTable();
    });
  }
}

class BeneficiaryRepository {
  void insertBeneficiary(Beneficiary beneficiary) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.beneficiaryDao.insertBeneficiary(beneficiary);
    });
  }

  Future<Future<List<Beneficiary>>?> getAllBeneficiaries() async {
    Future<List<Beneficiary>>? beneficiaries;

    await AppDatabase.getDatabaseInstance().then((database) {
      beneficiaries = database.beneficiaryDao.getAllBeneficiaries();
    });
    return beneficiaries;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.beneficiaryDao.clearTable();
    });
  }
}

class ModuleToHideRepository {
  void insertModuleToHide(ModuleToHide moduleToHide) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.moduleToHideDao.insertModuleToHide(moduleToHide);
    });
  }

  Future<Future<List<ModuleToHide>>?> getAllModulesToHide() async {
    Future<List<ModuleToHide>>? modulesToHide;

    await AppDatabase.getDatabaseInstance().then((database) {
      modulesToHide = database.moduleToHideDao.getAllModulesToHide();
    });
    return modulesToHide;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.moduleToHideDao.clearTable();
    });
  }
}

class ModuleToDisableRepository {
  void insertModuleToDisable(ModuleToDisable moduleToDisable) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.moduleToDisableDao.insertModuleToDisable(moduleToDisable);
    });
  }

  Future<Future<List<ModuleToDisable>>?> getAllModulesToDisable() async {
    Future<List<ModuleToDisable>>? modulesToDisable;

    await AppDatabase.getDatabaseInstance().then((database) {
      modulesToDisable = database.moduleToDisableDao.getAllModulesToDisable();
    });
    return modulesToDisable;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.moduleToDisableDao.clearTable();
    });
  }
}

class AtmLocationRepository {
  void insertAtmLocation(AtmLocation atmLocation) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.atmLocationDao.insertAtmLocation(atmLocation);
    });
  }

  Future<List<AtmLocation>> getAllAtmLocations() async {
    var atmLocations;
    await AppDatabase.getDatabaseInstance().then((database) {
      atmLocations = database.atmLocationDao.getAllAtmLocations();
    });
    return atmLocations;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.atmLocationDao.clearTable();
    });
  }
}

class BranchLocationRepository {
  void insertBranchLocation(BranchLocation branchLocation) async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.branchLocationDao.insertBranchLocation(branchLocation);
    });
  }

  Future<List<BranchLocation>> getAllBranchLocations() async {
    var branchLocations;
    await AppDatabase.getDatabaseInstance().then((database) {
      branchLocations = database.branchLocationDao.getAllBranchLocations();
    });
    return branchLocations;
  }

  void clearTable() async {
    AppDatabase.getDatabaseInstance().then((database) {
      database.branchLocationDao.clearTable();
    });
  }
}
