import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import '../friends.dart';

class FriendItemComponent extends StatelessWidget {
  final Friend friend;

  const FriendItemComponent({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        CachedNetworkImage(imageUrl: friend.avatar)
            .constrained(width: 56, height: 56),
        Text(friend.address)
      ],
    );
  }
}
