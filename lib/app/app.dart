import 'package:chat_client/app/data/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

import 'app_theme.dart';
import 'logic/logic.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  late MQtt mqtt;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        ).parent(({required child}) => MultiBlocProvider(providers: [
              BlocProvider(
                  create: (context) => ContactBloc(
                      repository: ContactRepository(cache: context.read())))
            ], child: child));
      },
      buildWhen: (prev, state) {
        return prev.user != state.user;
      },
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          context.read<MQtt>().connect(state.user);
          navigatorKey.currentState?.push(HomePage.route());
        } else {
          context.read<MQtt>().disconnect();
          navigatorKey.currentState?.push(SignUpPage.route());
        }
      },
    );
  }
}
