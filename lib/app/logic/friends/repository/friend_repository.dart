import 'dart:async';

import 'package:chat_client/app/data/cache.dart';

import '../../logic.dart';

class FriendRepository {
  final Cache cache;

  final StreamController<List<Friend>> _controller = StreamController();

  Stream<List<Friend>> get friends => _controller.stream.map((event) {
        cache.cacheFriends(event);
        return event;
      });

  FriendRepository({required this.cache});

  List<Friend> get currentFriends => cache.cachedFriends();

  void add(Friend friend) {
    final friends = currentFriends;
    if (!friends.contains(friend)) {
      _controller.add([...friends, friend]);
    }
  }

  void remove(Friend friend) {
    final friends = currentFriends;
    if (friends.remove(friend)) {
      _controller.add([...friends]);
    }
  }

  void dispose() {
    _controller.close();
  }
}
