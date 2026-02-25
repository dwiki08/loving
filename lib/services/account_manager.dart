import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../database/app_database.dart';

class AccountManager {
  final AppDatabase _db;

  AccountManager(this._db);

  Future<void> saveAccount(String username, String password) async {
    await _db
        .into(_db.accounts)
        .insertOnConflictUpdate(
          AccountsCompanion(
            username: Value(username),
            password: Value(password),
          ),
        );
  }

  Future<List<Account>> getAccounts() async {
    return await _db.select(_db.accounts).get();
  }

  Future<Account?> getAccount() async {
    return await _db.select(_db.accounts).getSingleOrNull();
  }

  Future<void> clearAccount() async {
    await _db.delete(_db.accounts).go();
  }
}

final accountManagerProvider = Provider<AccountManager>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AccountManager(db);
});
