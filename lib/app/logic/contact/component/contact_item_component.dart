import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import '../contact.dart';

class FriendItemComponent extends StatelessWidget {
  final Contact contact;

  const FriendItemComponent({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        CachedNetworkImage(imageUrl: contact.avatar)
            .constrained(width: 56, height: 56),
        Text(contact.address).padding(left: 8)
      ],
    );
  }
}
