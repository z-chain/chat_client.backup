import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../logic.dart';

class MessagePage extends StatelessWidget {
  AppBar _appBar() {
    return AppBar(
      leading: MyAvatar().padding(all: 4, left: 12),
      actions: [
        BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
          return IconButton(
              onPressed: () async {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  final bytes = await image.readAsBytes();
                  final code = await scanner.scanBytes(bytes);
                  context
                      .read<MessageBloc>()
                      .add(MessageReceived(user: User(public: code)));
                }
              },
              icon: Icon(Icons.qr_code_scanner));
        })
      ],
    );
  }

  Widget _messages(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
      return ListView.builder(
        itemBuilder: (context, index) {
          final item = state.messages[index];
          return MessageItem(
            avatar: item.user.avatar,
            name: item.user.address,
            message: '${item.lastMessage?.type ?? ''}',
            badge: item.badge,
            time: '${item.lastMessage?.createdAt ?? ''}',
          ).padding(horizontal: 12).ripple().gestures(
              onTap: () => Navigator.of(context)
                  .push(ChatPage.route(user: AuthenticationUser.random())));
        },
        itemCount: state.messages.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _messages(context),
    ).parent(({required child}) => BlocProvider(
          create: (context) =>
              MessageBloc(repository: MessageRepository(cache: context.read())),
          child: child,
        ));
  }
}
