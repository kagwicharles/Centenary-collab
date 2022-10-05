import 'package:floor/floor.dart';
import 'package:rafiki/src/data/user_model.dart';

@dao
abstract class BankAccountDao {
  @Query('SELECT * FROM BankAccount')
  Future<List<BankAccount>> getAllBankAccounts();

  @insert
  Future<void> insertBankAccount(BankAccount bankAccount);

  @Query('DELETE FROM BankAccount')
  Future<void> clearTable();
}

@dao
abstract class FrequentAccessedModuleDao {
  @Query('SELECT * FROM FrequentAccessedModule')
  Future<List<FrequentAccessedModule>> getAllFrequentModules();

  @insert
  Future<void> insertFrequentModule(
      FrequentAccessedModule frequentAccessedModule);

  @Query('DELETE FROM FrequentAccessedModule')
  Future<void> clearTable();
}

@dao
abstract class BeneficiaryDao {
  @Query('SELECT * FROM Beneficiary')
  Future<List<Beneficiary>> getAllBeneficiaries();

  @insert
  Future<void> insertBeneficiary(Beneficiary beneficiary);

  @Query('DELETE FROM Beneficiary')
  Future<void> clearTable();
}

@dao
abstract class ModuleToHideDao {
  @Query('SELECT * FROM ModuleToHide')
  Future<List<ModuleToHide>> getAllModulesToHide();

  @insert
  Future<void> insertModuleToHide(ModuleToHide moduleToHide);

  @Query('DELETE FROM ModuleToHide')
  Future<void> clearTable();
}

@dao
abstract class ModuleToDisableDao {
  @Query('SELECT * FROM ModuleToDisable')
  Future<List<ModuleToDisable>> getAllModulesToDisable();

  @insert
  Future<void> insertModuleToDisable(ModuleToDisable moduleToDisable);

  @Query('DELETE FROM ModuleToDisable')
  Future<void> clearTable();
}
