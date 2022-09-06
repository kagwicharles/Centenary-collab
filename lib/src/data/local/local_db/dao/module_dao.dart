import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class ModuleItemDao {
  @Query('SELECT * FROM ModuleItem WHERE parentModule = :parentModule')
  Future<List<ModuleItem>> getModulesById(String parentModule);

  @insert
  Future<void> insertModuleItem(ModuleItem moduleItem);

  @Query('DELETE FROM ModuleItem')
  Future<void> clearTable();
}
