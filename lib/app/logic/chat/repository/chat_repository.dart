import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_client/app/logic/user/user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:hex/hex.dart' show HEX;

class ChatRepository {
  late MqttClient? client;

  ChatRepository();

  Future<void> connect(
      {required String host,
      required int port,
      required String clientId}) async {
    client = MqttServerClient(host, clientId);
    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnect;
    client!.onSubscribed = _onSubscribe;
    client!.onSubscribeFail = _onSubscribeFailure;
    client!.onUnsubscribed = _onUnSubscribe;
    client!.logging(on: false);
    client!.keepAlivePeriod = 20;
    client!.connectionMessage = MqttConnectMessage()
        .withWillTopic('z-chain/chat/online-user/$clientId')
        .withWillMessage('')
        .withWillRetain()
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    client!.pongCallback = _onPong;
    await client!.connect();
    client!.subscribe('z-chain/chat/online-user/#', MqttQos.atMostOnce);
    client!.published!.listen((event) {
      final payload = MqttPublishPayload.bytesToStringAsString(event.payload.message);
      try {
        final bytes = HEX.decode(payload);
        final json = utf8.decode(bytes);
        final message = types.Message.fromJson(jsonDecode(json));
        _controller.add(message);
      } catch (ex) {
        log('parse message error $ex : $payload');
      }
    });
  }

  void disconnect() {
    client!.disconnect();
  }

  void subscribe(String topic) {
    client!.subscribe(topic, MqttQos.atMostOnce);
  }

  void _onConnected() {
    log('mqtt connected');
  }

  void _onDisconnect() {
    log('mqtt disconnected');
  }

  void _onSubscribe(String topic) {
    log('subscribe topic : $topic');
  }

  void _onSubscribeFailure(String topic) {
    log('subscribe failure topic : $topic');
  }

  void _onUnSubscribe(String? topic) {
    log('unSubscribe topic : $topic');
  }

  void _onPong() {
    log('pong');
  }

  void send(User user, types.Message message) {
    final msg = jsonEncode(message.toJson());
    final hex = HEX.encoder.convert(utf8.encode(msg));
    final builder = MqttClientPayloadBuilder()..addString(hex);
    client?.publishMessage('z-chain/chat/message/${user.address}',
        MqttQos.exactlyOnce, builder.payload!);
  }

  final StreamController<types.Message> _controller =
      StreamController.broadcast();

  Stream<types.Message> get messages => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
