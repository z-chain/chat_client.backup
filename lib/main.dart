import 'package:chat_client/app/data/cache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/app_components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  final Cache cache = Cache(sharedPreferences: sharedPreferences);

  AppComponents appComponents = AppComponents(cache: cache);

  runApp(appComponents.build(App()));
}
