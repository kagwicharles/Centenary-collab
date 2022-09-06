import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class FormItemDao {
  @Query('SELECT * FROM FormItem WHERE moduleId = :id')
  Future<List<FormItem>> getFormsByModuleId(String id);

  @insert
  Future<void> insertFormItem(FormItem formItem);

  @Query('DELETE FROM FormItem')
  Future<void> clearTable();
}
