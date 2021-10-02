import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_client/app/data/mqtt.dart';
import 'package:chat_client/app/logic/chat/repository/chat_repository.dart';
import 'package:chat_client/app/logic/user/user.dart';
import 'package:dartsv/dartsv.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic.dart';
import '../chat.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final Contact contact;

  final MQtt mqtt;

  late ChatRepository repository;

  late StreamSubscription _streamSubscription;

  ChatBloc({required this.mqtt, required this.contact})
      : super(ChatState.initial()) {
    repository = ChatRepository(contact: contact, mqtt: mqtt);
    _streamSubscription = this.repository.message.listen(_onReceivedMessage);
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
      this.repository.sent(event.message);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    repository.close();
    return super.close();
  }
}
