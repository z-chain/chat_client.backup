import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../logic.dart';
import '../chat.dart';

class ChatPage extends StatelessWidget {
  final Contact user;

  const ChatPage({Key? key, required this.user}) : super(key: key);

  static Route route({required Contact user}) => MaterialPageRoute(
      builder: (context) => ChatPage(
            user: user,
          ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      final me =
          types.User(id: state.user.address, imageUrl: state.user.avatar);
      return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
        return Chat(
                messages: state.messages,
                showUserAvatars: true,
                showUserNames: true,
                onSendPressed: (text) => context.read<ChatBloc>().add(ChatSent(
                    message: types.TextMessage(
                        author: me,
                        id: '${state.messages.length}',
                        text: text.text,
                        previewData: text.previewData,
                        metadata: text.metadata,
                        createdAt: DateTime.now().millisecondsSinceEpoch))),
                user: me)
            .parent(({required child}) => Scaffold(
                  appBar: AppBar(
                    title: Text('${this.user.address}'),
                  ),
                  body: child,
                ));
      });
    }).parent(({required child}) => BlocProvider(
          create: (context) => ChatBloc(contact: user, mqtt: context.read()),
          child: child,
        ));
  }
}
