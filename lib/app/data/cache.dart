import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../logic/logic.dart';

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

  static String _friendCacheKey = 'friends_cache_key';

  List<Friend> cachedFriends() {
    final strList = sharedPreferences.getStringList(_friendCacheKey) ?? [];
    return strList
        .map((e) => jsonDecode(e))
        .map((e) => Friend.fromJson(e))
        .toList();
  }

  void cacheFriends(List<Friend> friends) {
    sharedPreferences.setStringList(_friendCacheKey,
        friends.map((e) => e.toJson()).map((e) => jsonEncode(e)).toList());
  }
}
