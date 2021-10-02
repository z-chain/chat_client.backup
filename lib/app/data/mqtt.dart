import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_client/app/data/cache.dart';
import 'package:chat_client/app/logic/logic.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:hex/hex.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'chain_message.dart';

class MQtt {
  late MqttServerClient client;

  AuthenticationUser _authenticationUser = AuthenticationUser.empty;

  StreamSubscription? _updateStreamSubscription;

  final StreamController<ChainChatMessage> _chatController =
      StreamController.broadcast();

  final StreamController<ChainOnlineUser> _onlineUserController =
      StreamController.broadcast();

  final StreamController<List<Contact>> _contactController =
      StreamController.broadcast();

  Stream<ChainChatMessage> get chat => _chatController.stream;

  Stream<ChainOnlineUser> get online =>
      _onlineUserController.stream.map((event) {
        log('${event.public}');
        return event;
      });

  Stream<List<Contact>> get contacts => _contactController.stream;

  bool _connected = false;

  MQtt(String host) {
    client = MqttServerClient(host, '');
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnect;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFailure;
    client.onUnsubscribed = _onUnsubscribed;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.pongCallback = _onPong;
  }

  void _onConnected() {
    log('mqtt client connected');
    _connected = true;
    client.subscribe(_contactTopic(_authenticationUser), MqttQos.exactlyOnce);
    client.subscribe(_onLineUsersTopic, MqttQos.exactlyOnce);
    this.send(
        _onlineUserTopic(_authenticationUser),
        ChainOnlineUser(
            address: _authenticationUser.address,
            public: _authenticationUser.public,
            time: DateTime.now().millisecondsSinceEpoch));
    _updateStreamSubscription = client.updates!.listen((event) {
      event.forEach((element) {
        final MqttPublishMessage message =
            element.payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        try {
          final bytes = HEX.decoder.convert(payload);
          final json = jsonDecode(utf8.decode(bytes));
          final message = ChainMessage.fromJson(json);
          log('on message ${element.topic} ${message.type}');
          if (message is ChainChatMessage) {
            _chatController.add(message);
          } else if (message is ChainOnlineUser) {
            log('on line user : ${message.public}');
            _onlineUserController.add(message);
          } else if (message is ChainContacts) {
            _contactController.add(message.contacts);
          }
        } catch (e) {
          log('message decode error :$e $payload');
        }
      });
    });
  }

  void _onDisconnect() {
    log('mqtt client disconnected');
    _authenticationUser = AuthenticationUser.empty;
    _connected = false;
  }

  void _onSubscribed(String topic) {
    log('mqtt client subscribed : $topic');
  }

  void _onUnsubscribed(String? topic) {
    log('mqtt client unsubscribed : $topic');
  }

  void _onSubscribeFailure(String topic) {
    log('mqtt client subscribe failure: $topic');
  }

  void _onPong() {
    log('mqtt client on pong');
  }

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
    if (_connected && user != _authenticationUser) {
      return await this.disconnect();
    }
    _connected = true;
    _authenticationUser = user;
    client.clientIdentifier = user.address;
    client.connectionMessage = MqttConnectMessage()
        .withWillTopic(_onlineUserTopic(user))
        .withClientIdentifier(user.address)
        .withWillMessage('')
        .withWillRetain()
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    await client.connect();
  }

  Future<void> disconnect() async {
    if (_connected) {
      client.unsubscribe(_onLineUsersTopic);
      client.unsubscribe(_contactTopic(_authenticationUser));
      client.disconnect();
    }
  }

  int send(String topic, ChainMessage message, {bool retain = false}) {
    final json = jsonEncode(message.toJson());
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(HEX.encoder.convert(utf8.encode(json)));
    return client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!,
        retain: retain);
  }

  int sendTo(Contact contact, ChainMessage message, {bool retain = false}) {
    return this.send(_chatTopic(contact), message, retain: retain);
  }

  int updateContacts(List<Contact> contacts) {
    return this.send(
        _contactTopic(_authenticationUser),
        ChainContacts(
            contacts: contacts, time: DateTime.now().millisecondsSinceEpoch),
        retain: true);
  }

  void close() {
    _updateStreamSubscription?.cancel();
    _onlineUserController.close();
    _chatController.close();
    _contactController.close();
  }
}
