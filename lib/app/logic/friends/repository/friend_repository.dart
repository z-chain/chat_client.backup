import 'dart:async';
import 'dart:developer';

import 'package:chat_client/app/data/cache.dart';

import '../../logic.dart';

class FriendRepository {
  final Cache cache;

  final StreamController<List<User>> _controller = StreamController();

  Stream<List<User>> get friends => _controller.stream.map((event) {
        cache.cacheFriends(event);
        return event;
      });

  FriendRepository({required this.cache});

  List<User> get currentFriends => cache.cachedFriends();

  void add(User user) {
    final friends = currentFriends;
    if (!friends.contains(user)) {
      _controller.add([...friends, user]);
    }
  }

  void remove(User user) {
    final friends = currentFriends;
    if (friends.remove(user)) {
      _controller.add([...friends]);
    }
  }

  void dispose() {
    _controller.close();
  }
}
