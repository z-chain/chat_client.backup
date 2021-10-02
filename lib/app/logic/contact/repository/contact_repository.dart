import 'dart:async';

import 'package:chat_client/app/data/cache.dart';

import '../../logic.dart';
import '../contact.dart';

class ContactRepository {
  final Cache cache;

  StreamController<List<Contact>> _controller = StreamController.broadcast();

  late StreamSubscription _streamSubscription;

  Stream<List<Contact>> get contact => _controller.stream;

  ContactRepository({required this.cache}) {
    _streamSubscription = _controller.stream.listen((event) {
      cache.cacheContact(event);
    });
  }

  List<Contact> get currentContact => cache.cachedContact();

  void add(Contact contact) {
    _controller.add([...currentContact, contact]);
  }

  void remove(Contact contact) {
    _controller.add([...currentContact..remove(contact)]);
  }

  void dispose() {
    _controller.close();
    _streamSubscription.cancel();
  }
}
