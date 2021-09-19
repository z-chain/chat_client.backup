import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:meta/meta.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial());

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatSent) {
      yield this.state.copyWith(messages: [
        event.message,
        ...this.state.messages,
      ]);
    }
  }
}
