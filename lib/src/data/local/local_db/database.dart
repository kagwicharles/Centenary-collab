import 'dart:async';
import 'package:floor/floor.dart';
import 'package:rafiki/src/data/local/local_db/dao/form_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/module_dao.dart';
import 'package:rafiki/src/data/model.dart';

part 'database.g.dart';

@Database(version: 1, entities: [ModuleItem, FormItem])
abstract class AppDatabase extends FloorDatabase {
  ModuleItemDao get moduleItemDao;
  FormItemDao get formItemDao;

  static buildDb() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database;
  }
}
