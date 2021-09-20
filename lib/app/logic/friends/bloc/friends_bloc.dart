import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../logic.dart';
import '../friends.dart';

part 'friends_event.dart';

part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendsRepository repository;

  late StreamSubscription _streamSubscription;

  FriendsBloc({required this.repository})
      : super(FriendsState.initial(repository.currentFriends)) {
    _streamSubscription = repository.friends.listen(_onFriendsChanged);
  }

  void _onFriendsChanged(List<Friend> friends) =>
      this.add(FriendsChanged(friends: friends));

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    if (event is FriendsChanged) {
      yield this.state.copyWith(friends: event.friends);
    } else if (event is FriendsAdded) {
      repository.add(event.friend);
    } else if (event is FriendsRemoved) {
      repository.remove(event.friend);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
