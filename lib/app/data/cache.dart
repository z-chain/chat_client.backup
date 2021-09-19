import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../logic/authentication/model/authentication_user.dart';

class Cache {
  final SharedPreferences sharedPreferences;

  Cache({required this.sharedPreferences});

  static String _userCacheKey = 'user_cache_key';

  AuthenticationUser? cachedUser() {
    final jsonStr = sharedPreferences.getString(_userCacheKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    final json = jsonDecode(jsonStr);
    return AuthenticationUser.fromJson(json);
  }

  void cacheUser(AuthenticationUser user) {
    sharedPreferences.setString(_userCacheKey, jsonEncode(user.toJson()));
  }
}
