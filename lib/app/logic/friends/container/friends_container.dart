import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_client/app/logic/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:styled_widget/styled_widget.dart';

import '../friends.dart';

class FriendsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsBloc, FriendsState>(builder: (context, state) {
      return ListView.separated(
        itemCount: state.friends.length,
        itemBuilder: (context, index) {
          final item = state.friends[index];
          return FriendItemComponent(friend: item)
              .padding(horizontal: 12)
              .ripple()
              .gestures(
                  onTap: () =>
                      Navigator.of(context).push(ChatPage.route(user: item)))
              .height(64);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 1,
            width: double.maxFinite,
          ).backgroundColor(Colors.black12);
        },
      );
    });
  }
}
