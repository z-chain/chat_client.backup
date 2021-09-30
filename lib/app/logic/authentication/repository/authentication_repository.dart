import 'dart:async';


import '../../../data/cache.dart';
import '../authentication.dart';

class AuthenticationRepository {
  final Cache cache;

  final StreamController<AuthenticationUser> _controller = StreamController();

  AuthenticationRepository({required this.cache});

  Stream<AuthenticationUser> get user => _controller.stream.map((event) {
        cache.cacheUser(event);
        return event;
      });

  AuthenticationUser get currentUser =>
      cache.cachedUser() ?? AuthenticationUser.empty;

  Future<void> signUp(AuthenticationUser user) async {
    _controller.add(user);
  }

  Future<void> signOut() async {
    _controller.add(AuthenticationUser.empty);
  }

  void dispose() {
    _controller.close();
  }
}
