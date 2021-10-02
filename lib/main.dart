import 'package:chat_client/app/data/cache.dart';
import 'package:chat_client/app/data/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'app/app.dart';
import 'app/app_components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  final dbpath = join(await getDatabasesPath(), 'z-chain.db');

  final database =
      await openDatabase(dbpath, version: 1, onCreate: (db, version) {
    db.execute(
        'CREATE TABLE messages(id INTEGER PRIMARY KEY AUTOINCREMENT , address TEXT , message BLOB , time INTEGER)');
  });

  final MQtt mqtt = MQtt('broker-cn.emqx.io');

  final Cache cache =
      Cache(sharedPreferences: sharedPreferences, database: database,mqtt: mqtt );

  AppComponents appComponents = AppComponents(cache: cache, mqtt: mqtt);

  runApp(appComponents.build(App()));
}
