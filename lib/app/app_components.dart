import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

import 'data/cache.dart';

class AppComponents {
  final Cache cache;

  AppComponents({required this.cache});

  Widget build(BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [],
      child: child,
    ).parent(({required child}) => MultiRepositoryProvider(
          providers: [],
          child: child,
        ).parent(({required child}) => MultiProvider(
              providers: [
                Provider(
                  create: (context) => cache,
                )
              ],
              child: child,
            )));
  }
}
