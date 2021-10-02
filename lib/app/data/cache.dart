import 'dart:async';
import 'dart:convert';

import 'package:chat_client/app/data/chain_message.dart';
import 'package:chat_client/app/data/mqtt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../logic/logic.dart';

class Cache {
  final SharedPreferences sharedPreferences;

  final Database database;

  final MQtt mqtt;

  late StreamSubscription _mqttToCacheSubscription;

  Cache(
      {required this.sharedPreferences,
      required this.database,
      required this.mqtt}) {
    _mqttToCacheSubscription = mqtt.contacts.listen((event) {
      _contacts = event;
    });
  }

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

  List<Contact> _contacts = [];

  void cacheContact(List<Contact> contacts) {
    _contacts = contacts;
    mqtt.updateContacts(_contacts);
  }

  List<Contact> cachedContact() {
    return _contacts;
  }

  List<ChainOnlineUser> _onLineUsers = [];

  List<ChainOnlineUser> cachedOnlineUsers() {
    return _onLineUsers;
  }

  void close() {
    _mqttToCacheSubscription.cancel();
  }
}
