import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../user.dart';

class DialogUserQRCode extends StatelessWidget {
  static Future<void> show(BuildContext context, {required User user}) =>
      showDialog(
          context: context, builder: (context) => DialogUserQRCode(user: user));

  final User user;

  const DialogUserQRCode({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 24,
      children: [
        Text('${user.address}')
            .padding(all: 16)
            .backgroundColor(Colors.white70)
            .clipRRect(all: 256)
            .center(),
        UserQRCode(
          user: user,
        ).constrained(width: 256, height: 256).center()
      ],
    )
        .parent(({required child}) => Material(
              child: child,
              color: Colors.transparent,
            ))
        .center()
        .backgroundBlur(2);
  }
}
