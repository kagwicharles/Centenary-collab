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

  CarouselItemDao? _carouselItemDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `ModuleItem` (`moduleId` TEXT NOT NULL, `parentModule` TEXT NOT NULL, `moduleUrl` TEXT, `moduleName` TEXT NOT NULL, `moduleCategory` TEXT NOT NULL, PRIMARY KEY (`moduleId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FormItem` (`no` INTEGER, `controlType` TEXT, `controlText` TEXT, `moduleId` TEXT, `controlId` TEXT, `actionId` TEXT, `linkedToControl` TEXT, `formSequence` INTEGER, `serviceParamId` TEXT, `displayOrder` REAL, `controlFormat` TEXT, `isMandatory` INTEGER, `isEncrypted` INTEGER, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ActionItem` (`no` INTEGER, `moduleId` TEXT NOT NULL, `actionType` TEXT NOT NULL, `actionId` TEXT NOT NULL, `serviceParamsIds` TEXT NOT NULL, `controlId` TEXT NOT NULL, `webHeader` TEXT NOT NULL, `merchantId` TEXT, `formId` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserCode` (`no` INTEGER, `id` TEXT NOT NULL, `subCodeId` TEXT NOT NULL, `description` TEXT, `relationId` TEXT, `extraField` TEXT, `displayOrder` INTEGER, `isDefault` INTEGER, `extraFieldName` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OnlineAccountProduct` (`no` INTEGER, `id` TEXT, `description` TEXT, `relationId` TEXT, `url` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BankBranch` (`no` INTEGER, `description` TEXT, `relationId` TEXT, PRIMARY KEY (`no`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Carousel` (`no` INTEGER, `imageUrl` TEXT, `imageInfoUrl` TEXT, `imageCategory` TEXT, PRIMARY KEY (`no`))');

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
  CarouselItemDao get carouselItemDao {
    return _carouselItemDaoInstance ??=
        _$CarouselItemDao(database, changeListener);
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
                  'moduleCategory': item.moduleCategory
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
            moduleCategory: row['moduleCategory'] as String),
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
                  'isMandatory': item.isMandatory == null
                      ? null
                      : (item.isMandatory! ? 1 : 0),
                  'isEncrypted': item.isEncrypted == null
                      ? null
                      : (item.isEncrypted! ? 1 : 0)
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
            isMandatory: row['isMandatory'] == null
                ? null
                : (row['isMandatory'] as int) != 0,
            isEncrypted: row['isEncrypted'] == null
                ? null
                : (row['isEncrypted'] as int) != 0),
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

class _$CarouselItemDao extends CarouselItemDao {
  _$CarouselItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _carouselInsertionAdapter = InsertionAdapter(
            database,
            'Carousel',
            (Carousel item) => <String, Object?>{
                  'no': item.no,
                  'imageUrl': item.imageUrl,
                  'imageInfoUrl': item.imageInfoUrl,
                  'imageCategory': item.imageCategory
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Carousel> _carouselInsertionAdapter;

  @override
  Future<List<Carousel>> getAllCarousels() async {
    return _queryAdapter.queryList('SELECT * FROM Carousel',
        mapper: (Map<String, Object?> row) => Carousel(
            no: row['no'] as int?,
            imageUrl: row['imageUrl'] as String?,
            imageInfoUrl: row['imageInfoUrl'] as String?,
            imageCategory: row['imageCategory'] as String?));
  }

  @override
  Future<void> clearTable() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Carousel');
  }

  @override
  Future<void> insertCarousel(Carousel carousel) async {
    await _carouselInsertionAdapter.insert(carousel, OnConflictStrategy.abort);
  }
}
