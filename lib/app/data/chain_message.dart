import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

abstract class ChainMessage {
  final ChainMessageType type;

  final int time;

  ChainMessage({required this.type, required this.time});

  Map<String, dynamic> toJson();

  factory ChainMessage.fromJson(Map<String, dynamic> map) {
    final type = map['type'];
    if (type == 'chat') {
      return ChainChatMessage.fromJson(map);
    } else if (type == 'online_user') {
      return ChainOnlineUser.fromJson(map);
    } else {
      return ChainUnsupportedMessage.fromJson(map);
    }
  }
}

class ChainChatMessage extends ChainMessage {
  final String address;

  final types.Message message;

  ChainChatMessage(
      {required this.address, required this.message, required int time})
      : super(type: ChainMessageType.chat, time: time);

  factory ChainChatMessage.fromJson(Map<String, dynamic> map) {
    return ChainChatMessage(
      address: map['address'],
      message: types.Message.fromJson(map['message']),
      time: map['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'chat',
      'address': address,
      'message': message.toJson(),
      'time': time
    };
  }
}

class ChainOnlineUser extends ChainMessage {
  final String? public;

  ChainOnlineUser({required this.public, required int time})
      : super(type: ChainMessageType.online_user, time: time);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'online_user',
      'public': public,
      'time': time,
    };
  }

  factory ChainOnlineUser.fromJson(Map<String, dynamic> map) {
    return ChainOnlineUser(public: map['public'], time: map['time']);
  }
}

class ChainUnsupportedMessage extends ChainMessage {
  ChainUnsupportedMessage({required int time})
      : super(type: ChainMessageType.unsupported, time: time);

  factory ChainUnsupportedMessage.fromJson(Map<String, dynamic> map) {
    return ChainUnsupportedMessage(
        time: map['time'] ?? DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'unsupported', 'time': time};
  }
}

enum ChainMessageType { chat, online_user, unsupported }
