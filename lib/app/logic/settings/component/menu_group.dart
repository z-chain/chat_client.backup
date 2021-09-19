import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'menu_group_item.dart';

class MenuGroup extends StatelessWidget {
  final Widget? title;

  final List<MenuGroupItem> items;

  const MenuGroup({Key? key, this.title, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = this
        .items
        .asMap()
        .map((key, value) {
          return MapEntry(
              key,
              Column(
                children: [
                  value,
                  if (key != items.length - 1)
                    SizedBox(
                      width: double.maxFinite,
                      height: 1,
                    ).backgroundColor(Colors.black12).padding(horizontal: 12)
                ],
              ));
        })
        .values
        .toList();
    return Wrap(
      children: [
        if (this.title != null) this.title!,
        Column(
          children: list,
        )
      ],
    ).backgroundColor(Colors.white);
  }
}
