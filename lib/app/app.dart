import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

import 'app_theme.dart';
import 'logic/logic.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return MaterialApp(
        theme: AppTheme().light,
        onGenerateRoute: (settings) {
          if (state.status == AuthenticationStatus.authenticated) {
            return HomePage.route();
          } else {
            return SignUpPage.route();
          }
        },
      );
    });
  }
}
