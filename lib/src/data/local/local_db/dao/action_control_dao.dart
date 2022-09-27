import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class ActionControlDao {
  @Query(
      'SELECT * FROM ActionItem WHERE moduleId = :moduleId AND actionId = :actionId')
  Future<ActionItem?> getActionControlByModuleIdAndActionId(
      String moduleId, String actionId);

  @insert
  Future<void> insertActionControl(ActionItem actionItem);

  @Query('DELETE FROM ActionItem')
  Future<void> clearTable();
}
