import 'dart:async';
import 'package:chat_client/app/data/chain_message.dart';
import 'package:chat_client/app/data/mqtt.dart';
import 'package:chat_client/app/logic/contact/contact.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRepository {
  final MQtt mqtt;

  final Contact contact;

  late StreamSubscription _streamSubscription;

  ChatRepository({required this.contact, required this.mqtt}) {
    _streamSubscription = this
        .mqtt
        .chat
        .where((event) => event.address == this.contact.address)
        .listen((event) {
      _controller.add(event.message);
    });
  }

  final StreamController<types.Message> _controller =
      StreamController.broadcast();

  Stream<types.Message> get message => _controller.stream;

  void sent(types.Message message) {
    mqtt.sendTo(
        contact,
        ChainChatMessage(
            address: contact.address,
            message: message,
            time: DateTime.now().millisecondsSinceEpoch));
    this._controller.add(message);
  }

  void close() {
    _streamSubscription.cancel();
    _controller.close();
  }
}
