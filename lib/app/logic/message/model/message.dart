import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../logic.dart';

class Message {
  final User user;

  final int badge;

  final types.Message? lastMessage;

  const Message({required this.user, required this.badge, this.lastMessage});

  static const empty = const Message(user: User.empty, badge: 0);

  bool get isEmpty => this == empty;

  bool get isNotEmpty => this != empty;

  Message copyWith({User? user, types.Message? lastMessage, int? badge}) {
    return Message(
        user: user ?? this.user,
        badge: badge ?? this.badge,
        lastMessage: lastMessage ?? this.lastMessage);
  }
}
