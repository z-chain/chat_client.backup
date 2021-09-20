import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class MessageItem extends StatelessWidget {
  final String avatar;

  final String name;

  final String message;

  final String time;

  final int badge;

  const MessageItem(
      {Key? key,
      required this.avatar,
      required this.name,
      required this.message,
      required this.badge,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final avatar = CachedNetworkImage(
      imageUrl: this.avatar,
      width: 48,
      height: 48,
    ).padding(all: 4).backgroundColor(Colors.black38).clipRRect(all: 56);

    final name = Text(
      this.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ).textStyle(theme.textTheme.headline6!);

    final message =
        Text(this.message).textColor(theme.primaryColor.withOpacity(0.8));

    final time = Text('${this.time}').textColor(theme.disabledColor);

    final badge = this.badge != 0
        ? Text('${this.badge}')
            .textColor(theme.colorScheme.onPrimary)
            .fontSize(10)
            .center()
            .width(16)
            .height(16)
            .backgroundColor(theme.primaryColor)
            .clipRRect(all: 16)
        : SizedBox();

    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatar,
        Wrap(
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [name.expanded(), badge],
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [message.expanded(), time],
            )
          ],
        ).padding(left: 12).expanded()
      ],
    ).height(64);
  }
}
