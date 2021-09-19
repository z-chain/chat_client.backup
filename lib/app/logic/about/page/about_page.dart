import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_client/app/logic/settings/component/menu_group.dart';
import 'package:chat_client/app/logic/settings/component/menu_group_item.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:styled_widget/styled_widget.dart';

class AboutPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (context) => AboutPage());

  @override
  State<StatefulWidget> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  String appName = '';

  String packageName = '';

  String version = '';

  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      this.setState(() {
        appName = value.appName;
        packageName = value.packageName;
        version = value.version;
        buildNumber = value.buildNumber;
      });
    }).onError((error, stackTrace) {
      log('$error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于Z-Chat'),
      ),
      body: Wrap(
        runSpacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Image.asset('assets/images/logo.png')
              .constrained(height: 128, width: 128)
              .clipRRect(all: 128)
              .center(),
          MenuGroup(items: [
            MenuGroupItem(
              title: Text(appName).center(),
              child: SizedBox(),
            ),
            MenuGroupItem(
              title: Text('包名'),
              child: Text(this.packageName),
            ),
            MenuGroupItem(
              title: Text('版本'),
              child: Text('${this.version} (${this.buildNumber})'),
            ),
          ])
        ],
      ).padding(top: 128),
    );
  }
}
