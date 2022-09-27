import 'package:floor/floor.dart';
import 'package:rafiki/src/data/model.dart';

@dao
abstract class UserCodeDao {
  @Query('SELECT * FROM UserCode WHERE id = :id')
  Future<List<UserCode>> getUserCodesById(String id);

  @insert
  Future<void> inserUserCode(UserCode userCode);

  @Query('DELETE FROM UserCode')
  Future<void> clearTable();
}

@dao
abstract class OnlineAccountProductDao {
  @Query('SELECT * FROM OnlineAccountProduct')
  Future<List<OnlineAccountProduct>> getAllOnlineAccountProducts();

  @insert
  Future<void> insertOnlineAccountProduct(
      OnlineAccountProduct onlineAccountProduct);

  @Query('DELETE FROM OnlineAccountProduct')
  Future<void> clearTable();
}

@dao
abstract class BankBranchDao {
  @Query('SELECT * FROM BankBranch')
  Future<List<BankBranch>> getAllBankBranches();

  @insert
  Future<void> insertBankBranch(BankBranch bankBranch);

  @Query('DELETE FROM BankBranch')
  Future<void> clearTable();
}
