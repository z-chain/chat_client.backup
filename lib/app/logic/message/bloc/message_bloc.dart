import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../message.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository repository;

  late StreamSubscription _streamSubscription;

  MessageBloc({required this.repository}) : super(MessageState.initial()) {
    _streamSubscription = repository.message.listen((event) {
      this.add(MessageReceived(message: event));
    });
  }

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is MessageReceived) {
      yield* _mapReceivedToState(event);
    }
  }

  Stream<MessageState> _mapReceivedToState(MessageReceived event) async* {
    final message = this.state.messages.firstWhere(
        (element) => element.user.public == event.message.author.id,
        orElse: () => Message.empty);
    if (message.isNotEmpty) {
      yield this.state.copyWith(messages: [
        message.copyWith(lastMessage: event.message),
        ...state.messages..remove(message)
      ]);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
