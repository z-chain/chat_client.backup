import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../logic.dart';

class MessagePage extends StatelessWidget {
  AppBar _appBar() {
    return AppBar(
      leading: MyAvatar().padding(all: 4, left: 12),
      actions: [
        IconButton(
            onPressed: () => print('scan'), icon: Icon(Icons.qr_code_scanner))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return MessageItem(
            avatar: 'https://api.multiavatar.com/$index.png',
            name: 'name $index',
            message: 'message $index',
            badge: index,
            time: DateTime.now().toIso8601String(),
          )
              .padding(horizontal: 12)
              .ripple()
              .gestures(onTap: () => print('$index'));
        },
        itemCount: 50,
      ),
    );
  }
}
