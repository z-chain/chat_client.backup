import 'dart:async';
import 'dart:developer';

import 'package:chat_client/app/data/cache.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageRepository {
  final Cache cache;

  MessageRepository({required this.cache});

  StreamController<types.Message> _messageController =
      StreamController.broadcast();

  Stream<types.Message> get message => _messageController.stream.map((event) {
        log('cache message from : ${event.author.id}');
        return event;
      });

  void close() {
    _messageController.close();
  }
}
