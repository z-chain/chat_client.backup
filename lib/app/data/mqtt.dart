import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_client/app/logic/logic.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:hex/hex.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'chain_message.dart';

class MQtt {
  late MqttServerClient client;

  StreamSubscription? _updateStreamSubscription;

  final StreamController<ChainChatMessage> _chatController =
      StreamController.broadcast();

  final StreamController<ChainOnlineUser> _onlineUserController =
      StreamController.broadcast();

  Stream<ChainChatMessage> get chat => _chatController.stream;

  Stream<ChainOnlineUser> get online => _onlineUserController.stream;

  MQtt(String host) {
    client = MqttServerClient(host, '');
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnect;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFailure;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.pongCallback = _onPong;
  }

  void _onConnected() {}

  void _onDisconnect() {}

  void _onSubscribed(String topic) {}

  void _onSubscribeFailure(String topic) {}

  void _onPong() {}

  static String _onLineUsersTopic = 'z-chain/chat/online-users/#';

  static String _onlineUserTopic(User user) {
    return 'z-chain/chat/online-users/${user.address}';
  }

  static String _contactTopic(User user) {
    return 'z-chain/chat/contact/${user.address}';
  }

  static String _chatTopic(User user) {
    return 'z-chain/chat/message/${user.address}';
  }

  Future<void> connect(AuthenticationUser user) async {
    client.connectionMessage = MqttConnectMessage()
        .withWillTopic(_onlineUserTopic(user))
        .withClientIdentifier(user.address)
        .withWillMessage('')
        .withWillRetain()
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    await client.connect();
    client.subscribe(_contactTopic(user), MqttQos.exactlyOnce);
    client.subscribe(_onLineUsersTopic, MqttQos.exactlyOnce);
    this.send(
        _onlineUserTopic(user),
        ChainOnlineUser(
            public: user.public, time: DateTime.now().millisecondsSinceEpoch));
    _updateStreamSubscription = client.updates!.listen((event) {
      event.forEach((element) {
        final MqttPublishMessage message =
            element.payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        try {
          final json = jsonDecode(payload);
          final message = ChainMessage.fromJson(json);
          if (message is ChainChatMessage) {
            _chatController.add(message);
          } else if (message is ChainOnlineUser) {
            _onlineUserController.add(message);
          }
        } catch (e) {
          log('message decode error :$e $payload');
        }
      });
    });
  }

  void send(String topic, ChainMessage message) {
    final json = jsonEncode(message.toJson());
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(HEX.encoder.convert(utf8.encode(json)));
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void sendTo(Contact contact, ChainMessage message) {
    this.send(_chatTopic(contact), message);
  }

  void close() {
    _updateStreamSubscription?.cancel();
    _onlineUserController.close();
    _chatController.close();
  }
}
