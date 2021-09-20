part of 'friends_bloc.dart';

@immutable
class FriendsState {
  final List<User> friends;

  FriendsState({required this.friends});

  factory FriendsState.initial(List<User> friends) =>
      FriendsState(friends: friends);

  FriendsState copyWith({List<User>? friends}) {
    return FriendsState(friends: friends ?? this.friends);
  }
}
