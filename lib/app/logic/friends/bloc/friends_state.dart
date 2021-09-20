part of 'friends_bloc.dart';

@immutable
class FriendsState {
  final List<Friend> friends;

  FriendsState({required this.friends});

  factory FriendsState.initial(List<Friend> friends) =>
      FriendsState(friends: friends);

  FriendsState copyWith({List<Friend>? friends}) {
    return FriendsState(friends: friends ?? this.friends);
  }
}
