import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class MenuGroupItem extends StatelessWidget {
  final Widget title;

  final Widget? child;

  final VoidCallback? onPressed;

  const MenuGroupItem(
      {Key? key, required this.title, this.child, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = this.child == null
        ? Icon(
            Icons.keyboard_arrow_right,
            color: theme.disabledColor,
            size: 24,
          )
        : this.child!;

    var child = Flex(
      direction: Axis.horizontal,
      children: [title.expanded(flex: 1), button],
    ).height(52).padding(horizontal: 12).parent(({required child}) {
      if (this.onPressed != null) {
        return child.ripple().gestures(onTap: this.onPressed);
      }
      return child;
    });
    return child;
  }
}
