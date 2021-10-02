import 'package:chat_client/app/logic/logic.dart';
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
    } else if (type == 'contacts') {
      return ChainContacts.fromJson(map);
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
  final String? address;

  final String? public;

  ChainOnlineUser(
      {required this.address, required this.public, required int time})
      : super(type: ChainMessageType.online_user, time: time);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'online_user',
      'address': address,
      'public': public,
      'time': time,
    };
  }

  factory ChainOnlineUser.fromJson(Map<String, dynamic> map) {
    return ChainOnlineUser(
        address: map['address'] ?? '',
        public: map['public'],
        time: map['time']);
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

class ChainContacts extends ChainMessage {
  final List<Contact> contacts;

  ChainContacts({required this.contacts, required int time})
      : super(type: ChainMessageType.online_user, time: time);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'contacts',
      'contacts': contacts.map((e) => e.toJson()).toList(),
      'time': time,
    };
  }

  factory ChainContacts.fromJson(Map<String, dynamic> map) {
    return ChainContacts(
        contacts:
            (map['contacts'] as List).map((e) => Contact.fromJson(e)).toList(),
        time: map['time']);
  }
}

enum ChainMessageType { chat, online_user, contacts, unsupported }
