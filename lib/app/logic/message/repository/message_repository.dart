import 'dart:async';
import 'dart:developer';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MessageRepository {
  late MqttClient? client;

  MessageRepository();

  Future<void> connect(
      {required String host,
      required int port,
      required String clientId}) async {
    client = MqttServerClient.withPort(host, clientId, port);
    client?.onConnected = _onConnected;
    client?.onDisconnected = _onDisconnect;
    client?.onSubscribed = _onSubscribe;
    client?.onSubscribeFail = _onSubscribeFailure;
    client?.onUnsubscribed = _onUnSubscribe;
    client?.logging(on: true);
    client?.keepAlivePeriod = 60;
    client?.connectionMessage = MqttConnectMessage()
        .withWillTopic('z-chain/chat/online-user/$clientId')
        .withWillMessage('')
        .withWillRetain()
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    client?.updates?.listen((event) {
      event.forEach((element) {
        final MqttPublishMessage message =
            element.payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToString(message.payload.message);
        log('topic: ${element.topic} , message: $payload');
      });
    });
    client?.pongCallback = _onPong;
    await client?.connect();
    client?.publishMessage(
        'z-chain/chat/online-user/$clientId',
        MqttQos.exactlyOnce,
        (MqttClientPayloadBuilder()..addString('hello')).payload!,
        retain: true);
  }

  void disconnect() {
    client?.disconnect();
  }

  void subscribe(String topic) {
    client?.subscribe(topic, MqttQos.exactlyOnce);
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

  final StreamController<types.Message> _controller =
      StreamController.broadcast();

  void dispose() {
    _controller.close();
  }
}
