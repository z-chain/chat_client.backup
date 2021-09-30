import 'dart:async';

import 'package:chat_client/app/data/cache.dart';

import '../../logic.dart';
import '../contact.dart';

class ContactRepository {
  final Cache cache;

  final StreamController<List<Contact>> _controller = StreamController();

  Stream<List<Contact>> get friends => _controller.stream.map((event) {
        cache.cacheFriends(event);
        return event;
      });

  ContactRepository({required this.cache});

  List<Contact> get currentFriends => cache.cachedFriends();

  void add(Contact friend) {
    final friends = currentFriends;
    if (!friends.contains(friend)) {
      _controller.add([...friends, friend]);
    }
  }

  void remove(Contact friend) {
    final friends = currentFriends;
    if (friends.remove(friend)) {
      _controller.add([...friends]);
    }
  }

  void dispose() {
    _controller.close();
  }
}
