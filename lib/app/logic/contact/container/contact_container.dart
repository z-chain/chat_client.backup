import 'package:chat_client/app/logic/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:styled_widget/styled_widget.dart';

import '../contact.dart';

class ContactContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
      return ListView.separated(
        itemCount: state.contacts.length,
        itemBuilder: (context, index) {
          final item = state.contacts[index];
          return Slidable(
            key: ValueKey(item.address),
            child: FriendItemComponent(contact: item)
                .padding(all: 12)
                .ripple()
                .gestures(
                    onTap: () =>
                        Navigator.of(context).push(ChatPage.route(user: item))),
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                icon: Icons.delete_outline,
                color: theme.errorColor,
                onTap: () => context
                    .read<ContactBloc>()
                    .add(ContactRemoved(contact: item)),
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 1,
            width: double.maxFinite,
          ).backgroundColor(Colors.black12).padding(horizontal: 12);
        },
      );
    });
  }
}
