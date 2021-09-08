import 'dart:async';

import '../../../data/cache.dart';
import '../authentication.dart';

class AuthenticationRepository {
  final Cache cache;

  final StreamController<User> _controller = StreamController();

  AuthenticationRepository({required this.cache});

  Stream<User> get user => _controller.stream.map((event) {
        cache.cacheUser(event);
        return event;
      });

  User get currentUser => cache.cachedUser() ?? User.empty;

  Future<void> create() async {
    _controller.add(User(id: 'hello'));
  }

  Future<void> signOut() async {
    _controller.add(User.empty);
  }

  void dispose() {
    _controller.close();
  }
}
