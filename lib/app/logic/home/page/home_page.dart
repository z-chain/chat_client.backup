import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import '../../logic.dart';

class HomePage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => HomePage());

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      scaffold: MessagePage(),
      leftChild: SettingsPage(),
    );
  }
}
