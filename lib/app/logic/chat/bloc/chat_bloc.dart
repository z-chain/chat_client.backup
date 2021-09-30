import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_client/app/logic/user/user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:meta/meta.dart';

import '../chat.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  final User user;

  late StreamSubscription _streamSubscription;

  ChatBloc({required this.repository, required this.user})
      : super(ChatState.initial()) {
    _streamSubscription = repository.messages.listen(_onReceivedMessage);
  }

  void _onReceivedMessage(types.Message message) =>
      this.add(ChatReceived(message: message));

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatReceived) {
      yield this
          .state
          .copyWith(messages: [event.message, ...this.state.messages]);
    } else if (event is ChatSent) {
      this.repository.send(user, event.message);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
