import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class ModuleItemDao {
  @Query('SELECT * FROM ModuleItem WHERE id = :id')
  Stream<ModuleItem?> findModulesById(int id);

  @insert
  Future<void> insertModuleItem(ModuleItem moduleItem);
}
