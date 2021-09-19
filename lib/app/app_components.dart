import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:provider/provider.dart';
import 'data/cache.dart';
import 'logic/logic.dart';

class AppComponents {
  final Cache cache;

  AppComponents({required this.cache});

  Widget build(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthenticationBloc(repository: context.read()))
      ],
      child: child,
    )
        .parent(({required child}) => MultiRepositoryProvider(providers: [
              RepositoryProvider(
                  create: (context) => AuthenticationRepository(cache: cache))
            ], child: child))
        .parent(({required child}) => MultiProvider(
              providers: [
                Provider(create: (context) => cache),
              ],
              child: child,
            ));
  }
}
