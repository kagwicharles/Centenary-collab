import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class ActionControlDao {
  @Query('SELECT * FROM ActionItem WHERE moduleId = :id')
  Future<List<ActionItem>> getActionControlById(String id);

  @insert
  Future<void> insertActionControl(ActionItem actionItem);

  @Query('DELETE FROM ActionItem')
  Future<void> clearTable();
}
