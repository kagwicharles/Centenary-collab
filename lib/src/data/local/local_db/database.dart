import 'dart:async';
import 'package:floor/floor.dart';
import 'package:rafiki/src/data/local/local_db/dao/action_control_dao.dart';
import 'package:rafiki/src/data/local/local_db/dao/carousel_dao.dart';
import 'package:rafiki/src/data/local/local_db/dao/form_dao.dart';
import 'package:rafiki/src/data/local/local_db/dao/static_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/module_dao.dart';
import 'package:rafiki/src/data/model.dart';

part 'database.g.dart';

@Database(version: 1, entities: [
  ModuleItem,
  FormItem,
  ActionItem,
  UserCode,
  OnlineAccountProduct,
  BankBranch,
  Carousel
])
abstract class AppDatabase extends FloorDatabase {
  ModuleItemDao get moduleItemDao;
  FormItemDao get formItemDao;
  ActionControlDao get actionControlDao;
  UserCodeDao get userCodeDao;
  OnlineAccountProductDao get onlineAccountProductDao;
  BankBranchDao get bankBranchDao;
  CarouselItemDao get carouselItemDao;

  static getDatabaseInstance() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
