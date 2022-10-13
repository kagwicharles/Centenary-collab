// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ModuleItemDao? _moduleItemDaoInstance;

  FormItemDao? _formItemDaoInstance;

  ActionControlDao? _actionControlDaoInstance;

  UserCodeDao? _userCodeDaoInstance;

  OnlineAccountProductDao? _onlineAccountProductDaoInstance;

  BankBranchDao? _bankBranchDaoInstance;

  ImageDataDao? _imageDataDaoInstance;

  BankAccountDao? _bankAccountDaoInstance;

  FrequentAccessedModuleDao? _frequentAccessedModuleDaoInstance;

  BeneficiaryDao? _beneficiaryDaoInstance;

  ModuleToHideDao? _moduleToHideDaoInstance;

  ModuleToDisableDao? _moduleToDisableDaoInstance;

  AtmLocationDao? _atmLocationDaoInstance;

  BranchLocationDao? _branchLocationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ModuleItem` (`moduleId` TEXT NOT NULL, `parentModule` TEXT NOT NULL, `moduleUrl` TEXT, `moduleName` TEXT NOT NULL, `moduleCategory` TEXT NOT NULL, `merchantID` TEXT, PRIMARY KEY (`moduleId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FormItem` (`no` INTEGER, `controlType` TEXT, `controlText` TEXT, `moduleId` TEXT, `controlId` TEXT, `actionId` TEXT, `linkedToControl` TEXT, `formSequence` INTEGER, `serviceParamId` TEXT, `displayOrder` REAL, `controlFormat` TEXT, `dataSourceId` TEXT, `controlValue` TEXT, `isMandatory` INTEGER, `isEncrypted` INTEGER, `minValue` TEXT, `maxValue` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ActionItem` (`no` INTEGER, `moduleId` TEXT NOT NULL, `actionType` TEXT NOT NULL, `actionId` TEXT NOT NULL, `serviceParamsIds` TEXT NOT NULL, `controlId` TEXT NOT NULL, `webHeader` TEXT NOT NULL, `merchantId` TEXT, `formId` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserCode` (`no` INTEGER, `id` TEXT NOT NULL, `subCodeId` TEXT NOT NULL, `description` TEXT, `relationId` TEXT, `extraField` TEXT, `displayOrder` INTEGER, `isDefault` INTEGER, `extraFieldName` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OnlineAccountProduct` (`no` INTEGER, `id` TEXT, `description` TEXT, `relationId` TEXT, `url` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BankBranch` (`no` INTEGER, `description` TEXT, `relationId` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ImageData` (`no` INTEGER, `imageUrl` TEXT, `imageInfoUrl` TEXT, `imageCategory` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BankAccount` (`no` INTEGER, `bankAccountId` TEXT NOT NULL, `aliasName` TEXT NOT NULL, `currencyID` TEXT NOT NULL, `accountType` TEXT NOT NULL, `groupAccount` INTEGER NOT NULL, `defaultAccount` INTEGER NOT NULL, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FrequentAccessedModule` (`no` INTEGER, `parentModule` TEXT NOT NULL, `moduleID` TEXT NOT NULL, `moduleName` TEXT NOT NULL, `moduleCategory` TEXT NOT NULL, `moduleUrl` TEXT NOT NULL, `badgeColor` TEXT, `badgeText` TEXT, `merchantID` TEXT, `displayOrder` REAL, `containerID` TEXT, `lastAccessed` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Beneficiary` (`no` INTEGER, `merchantID` TEXT NOT NULL, `merchantName` TEXT NOT NULL, `accountID` TEXT NOT NULL, `accountAlias` TEXT NOT NULL, `bankID` TEXT, `branchID` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ModuleToHide` (`no` INTEGER, `moduleId` TEXT NOT NULL, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ModuleToDisable` (`no` INTEGER, `moduleID` TEXT NOT NULL, `merchantID` TEXT, `displayMessage` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AtmLocation` (`no` INTEGER, `longitude` REAL NOT NULL, `latitude` REAL NOT NULL, `distance` REAL NOT NULL, `location` TEXT NOT NULL, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BranchLocation` (`no` INTEGER, `longitude` REAL NOT NULL, `latitude` REAL NOT NULL, `distance` REAL NOT NULL, `location` TEXT NOT NULL, PRIMARY KEY (`no`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ModuleItemDao get moduleItemDao {
    return _moduleItemDaoInstance ??= _$ModuleItemDao(database, changeListener);
  }

  @override
  FormItemDao get formItemDao {
    return _formItemDaoInstance ??= _$FormItemDao(database, changeListener);
  }

  @override
  ActionControlDao get actionControlDao {
    return _actionControlDaoInstance ??=
        _$ActionControlDao(database, changeListener);
  }

  @override
  UserCodeDao get userCodeDao {
    return _userCodeDaoInstance ??= _$UserCodeDao(database, changeListener);
  }

  @override
  OnlineAccountProductDao get onlineAccountProductDao {
    return _onlineAccountProductDaoInstance ??=
        _$OnlineAccountProductDao(database, changeListener);
  }

  @override
  BankBranchDao get bankBranchDao {
    return _bankBranchDaoInstance ??= _$BankBranchDao(database, changeListener);
  }

  @override
  ImageDataDao get imageDataDao {
    return _imageDataDaoInstance ??= _$ImageDataDao(database, changeListener);
  }

  @override
  BankAccountDao get bankAccountDao {
    return _bankAccountDaoInstance ??=
        _$BankAccountDao(database, changeListener);
  }

  @override
  FrequentAccessedModuleDao get frequentAccessedModuleDao {
    return _frequentAccessedModuleDaoInstance ??=
        _$FrequentAccessedModuleDao(database, changeListener);
  }

  @override
  BeneficiaryDao get beneficiaryDao {
    return _beneficiaryDaoInstance ??=
        _$BeneficiaryDao(database, changeListener);
  }

  @override
  ModuleToHideDao get moduleToHideDao {
    return _moduleToHideDaoInstance ??=
        _$ModuleToHideDao(database, changeListener);
  }

  @override
  ModuleToDisableDao get moduleToDisableDao {
    return _moduleToDisableDaoInstance ??=
        _$ModuleToDisableDao(database, changeListener);
  }

  @override
  AtmLocationDao get atmLocationDao {
    return _atmLocationDaoInstance ??=
        _$AtmLocationDao(database, changeListener);
  }

  @override
  BranchLocationDao get branchLocationDao {
    return _branchLocationDaoInstance ??=
        _$BranchLocationDao(database, changeListener);
  }
}

class _$ModuleItemDao extends ModuleItemDao {
  _$ModuleItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _moduleItemInsertionAdapter = InsertionAdapter(
            database,
            'ModuleItem',
            (ModuleItem item) => <String, Object?>{
                  'moduleId': item.moduleId,
                  'parentModule': item.parentModule,
                  'moduleUrl': item.moduleUrl,
                  'moduleName': item.moduleName,
                  'moduleCategory': item.moduleCategory,
                  'merchantID': item.merchantID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ModuleItem> _moduleItemInsertionAdapter;

  @override
  Future<List<ModuleItem>> getModulesById(String parentModule) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ModuleItem WHERE parentModule = ?1',
        mapper: (Map<String, Object?> row) => ModuleItem(
            parentModule: row['parentModule'] as String,
            moduleUrl: row['moduleUrl'] as String?,
            moduleId: row['moduleId'] as String,
            moduleName: row['moduleName'] as String,
            moduleCategory: row['moduleCategory'] as String,
            merchantID: row['merchantID'] as String?),
        arguments: [parentModule]);
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ModuleItem');
  }

  @override
  Future<void> insertModuleItem(ModuleItem moduleItem) async {
    await _moduleItemInsertionAdapter.insert(
        moduleItem, OnConflictStrategy.abort);
  }
}

class _$FormItemDao extends FormItemDao {
  _$FormItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _formItemInsertionAdapter = InsertionAdapter(
            database,
            'FormItem',
            (FormItem item) => <String, Object?>{
                  'no': item.no,
                  'controlType': item.controlType,
                  'controlText': item.controlText,
                  'moduleId': item.moduleId,
                  'controlId': item.controlId,
                  'actionId': item.actionId,
                  'linkedToControl': item.linkedToControl,
                  'formSequence': item.formSequence,
                  'serviceParamId': item.serviceParamId,
                  'displayOrder': item.displayOrder,
                  'controlFormat': item.controlFormat,
                  'dataSourceId': item.dataSourceId,
                  'controlValue': item.controlValue,
                  'isMandatory': item.isMandatory == null
                      ? null
                      : (item.isMandatory! ? 1 : 0),
                  'isEncrypted': item.isEncrypted == null
                      ? null
                      : (item.isEncrypted! ? 1 : 0),
                  'minValue': item.minValue,
                  'maxValue': item.maxValue
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FormItem> _formItemInsertionAdapter;

  @override
  Future<List<FormItem>> getFormsByModuleId(String id) async {
    return _queryAdapter.queryList('SELECT * FROM FormItem WHERE moduleId = ?1',
        mapper: (Map<String, Object?> row) => FormItem(
            controlType: row['controlType'] as String?,
            controlText: row['controlText'] as String?,
            moduleId: row['moduleId'] as String?,
            linkedToControl: row['linkedToControl'] as String?,
            controlId: row['controlId'] as String?,
            actionId: row['actionId'] as String?,
            formSequence: row['formSequence'] as int?,
            serviceParamId: row['serviceParamId'] as String?,
            displayOrder: row['displayOrder'] as double?,
            controlFormat: row['controlFormat'] as String?,
            dataSourceId: row['dataSourceId'] as String?,
            controlValue: row['controlValue'] as String?,
            isMandatory: row['isMandatory'] == null
                ? null
                : (row['isMandatory'] as int) != 0,
            isEncrypted: row['isEncrypted'] == null
                ? null
                : (row['isEncrypted'] as int) != 0,
            minValue: row['minValue'] as String?,
            maxValue: row['maxValue'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM FormItem');
  }

  @override
  Future<void> insertFormItem(FormItem formItem) async {
    await _formItemInsertionAdapter.insert(formItem, OnConflictStrategy.abort);
  }
}

class _$ActionControlDao extends ActionControlDao {
  _$ActionControlDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _actionItemInsertionAdapter = InsertionAdapter(
            database,
            'ActionItem',
            (ActionItem item) => <String, Object?>{
                  'no': item.no,
                  'moduleId': item.moduleId,
                  'actionType': item.actionType,
                  'actionId': item.actionId,
                  'serviceParamsIds': item.serviceParamsIds,
                  'controlId': item.controlId,
                  'webHeader': item.webHeader,
                  'merchantId': item.merchantId,
                  'formId': item.formId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ActionItem> _actionItemInsertionAdapter;

  @override
  Future<ActionItem?> getActionControlByModuleIdAndActionId(
      String moduleId, String actionId) async {
    return _queryAdapter.query(
        'SELECT * FROM ActionItem WHERE moduleId = ?1 AND actionId = ?2',
        mapper: (Map<String, Object?> row) => ActionItem(
            moduleId: row['moduleId'] as String,
            actionType: row['actionType'] as String,
            actionId: row['actionId'] as String,
            serviceParamsIds: row['serviceParamsIds'] as String,
            controlId: row['controlId'] as String,
            webHeader: row['webHeader'] as String,
            formId: row['formId'] as String?,
            merchantId: row['merchantId'] as String?),
        arguments: [moduleId, actionId]);
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ActionItem');
  }

  @override
  Future<void> insertActionControl(ActionItem actionItem) async {
    await _actionItemInsertionAdapter.insert(
        actionItem, OnConflictStrategy.abort);
  }
}

class _$UserCodeDao extends UserCodeDao {
  _$UserCodeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userCodeInsertionAdapter = InsertionAdapter(
            database,
            'UserCode',
            (UserCode item) => <String, Object?>{
                  'no': item.no,
                  'id': item.id,
                  'subCodeId': item.subCodeId,
                  'description': item.description,
                  'relationId': item.relationId,
                  'extraField': item.extraField,
                  'displayOrder': item.displayOrder,
                  'isDefault':
                      item.isDefault == null ? null : (item.isDefault! ? 1 : 0),
                  'extraFieldName': item.extraFieldName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserCode> _userCodeInsertionAdapter;

  @override
  Future<List<UserCode>> getUserCodesById(String id) async {
    return _queryAdapter.queryList('SELECT * FROM UserCode WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserCode(
            id: row['id'] as String,
            subCodeId: row['subCodeId'] as String,
            description: row['description'] as String?,
            relationId: row['relationId'] as String?,
            extraField: row['extraField'] as String?,
            displayOrder: row['displayOrder'] as int?,
            isDefault: row['isDefault'] == null
                ? null
                : (row['isDefault'] as int) != 0,
            extraFieldName: row['extraFieldName'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserCode');
  }

  @override
  Future<void> insertUserCode(UserCode userCode) async {
    await _userCodeInsertionAdapter.insert(userCode, OnConflictStrategy.abort);
  }
}

class _$OnlineAccountProductDao extends OnlineAccountProductDao {
  _$OnlineAccountProductDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _onlineAccountProductInsertionAdapter = InsertionAdapter(
            database,
            'OnlineAccountProduct',
            (OnlineAccountProduct item) => <String, Object?>{
                  'no': item.no,
                  'id': item.id,
                  'description': item.description,
                  'relationId': item.relationId,
                  'url': item.url
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OnlineAccountProduct>
      _onlineAccountProductInsertionAdapter;

  @override
  Future<List<OnlineAccountProduct>> getAllOnlineAccountProducts() async {
    return _queryAdapter.queryList('SELECT * FROM OnlineAccountProduct',
        mapper: (Map<String, Object?> row) => OnlineAccountProduct(
            id: row['id'] as String?,
            description: row['description'] as String?,
            relationId: row['relationId'] as String?,
            url: row['url'] as String?));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM OnlineAccountProduct');
  }

  @override
  Future<void> insertOnlineAccountProduct(
      OnlineAccountProduct onlineAccountProduct) async {
    await _onlineAccountProductInsertionAdapter.insert(
        onlineAccountProduct, OnConflictStrategy.abort);
  }
}

class _$BankBranchDao extends BankBranchDao {
  _$BankBranchDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _bankBranchInsertionAdapter = InsertionAdapter(
            database,
            'BankBranch',
            (BankBranch item) => <String, Object?>{
                  'no': item.no,
                  'description': item.description,
                  'relationId': item.relationId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BankBranch> _bankBranchInsertionAdapter;

  @override
  Future<List<BankBranch>> getAllBankBranches() async {
    return _queryAdapter.queryList('SELECT * FROM BankBranch',
        mapper: (Map<String, Object?> row) => BankBranch(
            description: row['description'] as String?,
            relationId: row['relationId'] as String?));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM BankBranch');
  }

  @override
  Future<void> insertBankBranch(BankBranch bankBranch) async {
    await _bankBranchInsertionAdapter.insert(
        bankBranch, OnConflictStrategy.abort);
  }
}

class _$ImageDataDao extends ImageDataDao {
  _$ImageDataDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _imageDataInsertionAdapter = InsertionAdapter(
            database,
            'ImageData',
            (ImageData item) => <String, Object?>{
                  'no': item.no,
                  'imageUrl': item.imageUrl,
                  'imageInfoUrl': item.imageInfoUrl,
                  'imageCategory': item.imageCategory
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ImageData> _imageDataInsertionAdapter;

  @override
  Future<List<ImageData>> getAllImages(String imageType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ImageData WHERE imageCategory = ?1',
        mapper: (Map<String, Object?> row) => ImageData(
            no: row['no'] as int?,
            imageUrl: row['imageUrl'] as String?,
            imageInfoUrl: row['imageInfoUrl'] as String?,
            imageCategory: row['imageCategory'] as String?),
        arguments: [imageType]);
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ImageData');
  }

  @override
  Future<void> insertImage(ImageData imageData) async {
    await _imageDataInsertionAdapter.insert(
        imageData, OnConflictStrategy.abort);
  }
}

class _$BankAccountDao extends BankAccountDao {
  _$BankAccountDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _bankAccountInsertionAdapter = InsertionAdapter(
            database,
            'BankAccount',
            (BankAccount item) => <String, Object?>{
                  'no': item.no,
                  'bankAccountId': item.bankAccountId,
                  'aliasName': item.aliasName,
                  'currencyID': item.currencyID,
                  'accountType': item.accountType,
                  'groupAccount': item.groupAccount ? 1 : 0,
                  'defaultAccount': item.defaultAccount ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BankAccount> _bankAccountInsertionAdapter;

  @override
  Future<List<BankAccount>> getAllBankAccounts() async {
    return _queryAdapter.queryList('SELECT * FROM BankAccount',
        mapper: (Map<String, Object?> row) => BankAccount(
            bankAccountId: row['bankAccountId'] as String,
            aliasName: row['aliasName'] as String,
            currencyID: row['currencyID'] as String,
            accountType: row['accountType'] as String,
            groupAccount: (row['groupAccount'] as int) != 0,
            defaultAccount: (row['defaultAccount'] as int) != 0));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM BankAccount');
  }

  @override
  Future<void> insertBankAccount(BankAccount bankAccount) async {
    await _bankAccountInsertionAdapter.insert(
        bankAccount, OnConflictStrategy.abort);
  }
}

class _$FrequentAccessedModuleDao extends FrequentAccessedModuleDao {
  _$FrequentAccessedModuleDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _frequentAccessedModuleInsertionAdapter = InsertionAdapter(
            database,
            'FrequentAccessedModule',
            (FrequentAccessedModule item) => <String, Object?>{
                  'no': item.no,
                  'parentModule': item.parentModule,
                  'moduleID': item.moduleID,
                  'moduleName': item.moduleName,
                  'moduleCategory': item.moduleCategory,
                  'moduleUrl': item.moduleUrl,
                  'badgeColor': item.badgeColor,
                  'badgeText': item.badgeText,
                  'merchantID': item.merchantID,
                  'displayOrder': item.displayOrder,
                  'containerID': item.containerID,
                  'lastAccessed': item.lastAccessed
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FrequentAccessedModule>
      _frequentAccessedModuleInsertionAdapter;

  @override
  Future<List<FrequentAccessedModule>> getAllFrequentModules() async {
    return _queryAdapter.queryList('SELECT * FROM FrequentAccessedModule',
        mapper: (Map<String, Object?> row) => FrequentAccessedModule(
            parentModule: row['parentModule'] as String,
            moduleID: row['moduleID'] as String,
            moduleName: row['moduleName'] as String,
            moduleCategory: row['moduleCategory'] as String,
            moduleUrl: row['moduleUrl'] as String,
            merchantID: row['merchantID'] as String?,
            badgeColor: row['badgeColor'] as String?,
            badgeText: row['badgeText'] as String?,
            displayOrder: row['displayOrder'] as double?,
            containerID: row['containerID'] as String?,
            lastAccessed: row['lastAccessed'] as String?));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM FrequentAccessedModule');
  }

  @override
  Future<void> insertFrequentModule(
      FrequentAccessedModule frequentAccessedModule) async {
    await _frequentAccessedModuleInsertionAdapter.insert(
        frequentAccessedModule, OnConflictStrategy.abort);
  }
}

class _$BeneficiaryDao extends BeneficiaryDao {
  _$BeneficiaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _beneficiaryInsertionAdapter = InsertionAdapter(
            database,
            'Beneficiary',
            (Beneficiary item) => <String, Object?>{
                  'no': item.no,
                  'merchantID': item.merchantID,
                  'merchantName': item.merchantName,
                  'accountID': item.accountID,
                  'accountAlias': item.accountAlias,
                  'bankID': item.bankID,
                  'branchID': item.branchID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Beneficiary> _beneficiaryInsertionAdapter;

  @override
  Future<List<Beneficiary>> getAllBeneficiaries(String merchantID) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Beneficiary WHERE merchantID =?1',
        mapper: (Map<String, Object?> row) => Beneficiary(
            merchantID: row['merchantID'] as String,
            merchantName: row['merchantName'] as String,
            accountID: row['accountID'] as String,
            accountAlias: row['accountAlias'] as String,
            bankID: row['bankID'] as String?,
            branchID: row['branchID'] as String?),
        arguments: [merchantID]);
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Beneficiary');
  }

  @override
  Future<void> insertBeneficiary(Beneficiary beneficiary) async {
    await _beneficiaryInsertionAdapter.insert(
        beneficiary, OnConflictStrategy.abort);
  }
}

class _$ModuleToHideDao extends ModuleToHideDao {
  _$ModuleToHideDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _moduleToHideInsertionAdapter = InsertionAdapter(
            database,
            'ModuleToHide',
            (ModuleToHide item) =>
                <String, Object?>{'no': item.no, 'moduleId': item.moduleId});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ModuleToHide> _moduleToHideInsertionAdapter;

  @override
  Future<List<ModuleToHide>> getAllModulesToHide() async {
    return _queryAdapter.queryList('SELECT * FROM ModuleToHide',
        mapper: (Map<String, Object?> row) =>
            ModuleToHide(moduleId: row['moduleId'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ModuleToHide');
  }

  @override
  Future<void> insertModuleToHide(ModuleToHide moduleToHide) async {
    await _moduleToHideInsertionAdapter.insert(
        moduleToHide, OnConflictStrategy.abort);
  }
}

class _$ModuleToDisableDao extends ModuleToDisableDao {
  _$ModuleToDisableDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _moduleToDisableInsertionAdapter = InsertionAdapter(
            database,
            'ModuleToDisable',
            (ModuleToDisable item) => <String, Object?>{
                  'no': item.no,
                  'moduleID': item.moduleID,
                  'merchantID': item.merchantID,
                  'displayMessage': item.displayMessage
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ModuleToDisable> _moduleToDisableInsertionAdapter;

  @override
  Future<List<ModuleToDisable>> getAllModulesToDisable() async {
    return _queryAdapter.queryList('SELECT * FROM ModuleToDisable',
        mapper: (Map<String, Object?> row) => ModuleToDisable(
            moduleID: row['moduleID'] as String,
            merchantID: row['merchantID'] as String?,
            displayMessage: row['displayMessage'] as String?));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ModuleToDisable');
  }

  @override
  Future<void> insertModuleToDisable(ModuleToDisable moduleToDisable) async {
    await _moduleToDisableInsertionAdapter.insert(
        moduleToDisable, OnConflictStrategy.abort);
  }
}

class _$AtmLocationDao extends AtmLocationDao {
  _$AtmLocationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _atmLocationInsertionAdapter = InsertionAdapter(
            database,
            'AtmLocation',
            (AtmLocation item) => <String, Object?>{
                  'no': item.no,
                  'longitude': item.longitude,
                  'latitude': item.latitude,
                  'distance': item.distance,
                  'location': item.location
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AtmLocation> _atmLocationInsertionAdapter;

  @override
  Future<List<AtmLocation>> getAllAtmLocations() async {
    return _queryAdapter.queryList('SELECT * FROM AtmLocation',
        mapper: (Map<String, Object?> row) => AtmLocation(
            longitude: row['longitude'] as double,
            latitude: row['latitude'] as double,
            distance: row['distance'] as double,
            location: row['location'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM AtmLocation');
  }

  @override
  Future<void> insertAtmLocation(AtmLocation atmLocation) async {
    await _atmLocationInsertionAdapter.insert(
        atmLocation, OnConflictStrategy.abort);
  }
}

class _$BranchLocationDao extends BranchLocationDao {
  _$BranchLocationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _branchLocationInsertionAdapter = InsertionAdapter(
            database,
            'BranchLocation',
            (BranchLocation item) => <String, Object?>{
                  'no': item.no,
                  'longitude': item.longitude,
                  'latitude': item.latitude,
                  'distance': item.distance,
                  'location': item.location
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BranchLocation> _branchLocationInsertionAdapter;

  @override
  Future<List<BranchLocation>> getAllBranchLocations() async {
    return _queryAdapter.queryList('SELECT * FROM BranchLocation',
        mapper: (Map<String, Object?> row) => BranchLocation(
            longitude: row['longitude'] as double,
            latitude: row['latitude'] as double,
            distance: row['distance'] as double,
            location: row['location'] as String));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM BranchLocation');
  }

  @override
  Future<void> insertBranchLocation(BranchLocation branchLocation) async {
    await _branchLocationInsertionAdapter.insert(
        branchLocation, OnConflictStrategy.abort);
  }
}
