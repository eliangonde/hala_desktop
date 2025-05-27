import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';

extension UserCRUD on DatabaseHelper {
  Future<void> saveUserIfNotExists(
    Map<String, dynamic> userData,
    String token,
  ) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'api_id = ?',
      whereArgs: [userData['id']],
    );
    if (result.isEmpty) {
      await db.insert('users', {
        'api_id': userData['id'],
        'username': userData['name'],
        'email': userData['email'],
        'api_token': token,
        'created_at': userData['created_at'],
        'updated_at': userData['updated_at'],
      });
    }
  }

  Future<int?> getLocalUserIdFromApiId(int apiId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'api_id = ?',
      whereArgs: [apiId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first['id'] as int : null;
  }

  Future<int?> getCurrentLocalUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final apiId = prefs.getInt('current_user_api_id');
    if (apiId == null) return null;
    return await getLocalUserIdFromApiId(apiId);
  }

  Future<Map<String, dynamic>?> getLoggedInUser() async {
    final db = await database;
    final result = await db.query('users');
    return result.isNotEmpty ? result.last : null;
  }

  Future<void> updateUserInfo({
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final db = await database;
    final userId = await getCurrentLocalUserId();
    if (userId == null) return;

    await db.update(
      'users',
      {
        'username': name,
        'email': email,
        'phone_number': phoneNumber,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
