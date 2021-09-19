import 'package:chat_client/app/logic/settings/component/menu_group.dart';
import 'package:chat_client/app/logic/settings/component/menu_group_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../logic.dart';

class SettingsPage extends StatelessWidget {
  Widget _userInfo() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        MyAvatar()
            .constrained(width: 96, height: 96)
            .alignment(Alignment.centerLeft)
            .expanded(),
        IconButton(onPressed: () => print('go'), icon: Icon(Icons.qr_code))
      ],
    ).padding(horizontal: 12).height(256);
  }

  Widget _settings(BuildContext context) {
    return Wrap(
      runSpacing: 12,
      children: [
        MenuGroup(items: [
          MenuGroupItem(title: Text('帐号安全'), onPressed: () => print('帐号安全')),
        ]),
        MenuGroup(items: [
          MenuGroupItem(
              title: Text('消息通知'),
              child: CupertinoSwitch(
                value: true,
                onChanged: (value) => print('value'),
              )),
        ]),
        MenuGroup(items: [
          MenuGroupItem(title: Text('隐私安全'), onPressed: () => print('隐私安全')),
        ]),
        MenuGroup(items: [
          MenuGroupItem(
              title: Text('关于 Z-Chat').center(),
              child: SizedBox(),
              onPressed: () => Navigator.of(context).push(AboutPage.route())),
          MenuGroupItem(
              title: Text('帮助与反馈').center(),
              child: SizedBox(),
              onPressed: () => print('帮助与反馈')),
        ]),
        MenuGroup(items: [
          MenuGroupItem(
              title: Text('退出').center(),
              child: SizedBox(),
              onPressed: () => print('退出')),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          _userInfo(),
          _settings(context).scrollable().expanded(),
        ],
      ),
    );
  }
}
