import 'dart:async';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRepository {
  final StreamController<types.Message> _controller =
      StreamController.broadcast();

  Stream<types.Message> get message => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
