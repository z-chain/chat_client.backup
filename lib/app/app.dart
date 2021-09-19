import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'logic/logic.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return MaterialApp(
          theme: AppTheme().light,
          navigatorKey: navigatorKey,
          onGenerateRoute: (settings) {
            if (state.status == AuthenticationStatus.authenticated) {
              return HomePage.route();
            } else {
              return SignUpPage.route();
            }
          },
        );
      },
      buildWhen: (prev, state) {
        return prev.user != state.user;
      },
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          navigatorKey.currentState?.push(HomePage.route());
        } else {
          navigatorKey.currentState?.push(SignUpPage.route());
        }
      },
    );
  }
}
