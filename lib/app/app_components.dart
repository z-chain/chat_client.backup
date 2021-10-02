import 'package:chat_client/app/data/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'data/cache.dart';
import 'logic/logic.dart';

class AppComponents {
  final Cache cache;

  final MQtt mqtt;

  AppComponents({required this.cache, required this.mqtt});

  Widget build(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthenticationBloc(
                repository: AuthenticationRepository(cache: cache))),
      ],
      child: child,
    ).parent(({required child}) => MultiProvider(
          providers: [
            Provider(create: (context) => cache),
            Provider(create: (context) => mqtt)
          ],
          child: child,
        ));
  }
}
