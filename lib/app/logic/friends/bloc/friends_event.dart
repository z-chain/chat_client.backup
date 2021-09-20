part of 'friends_bloc.dart';

@immutable
abstract class FriendsEvent {}

class FriendsAdded extends FriendsEvent {
  final User user;

  FriendsAdded({required this.user});
}

class FriendsRemoved extends FriendsEvent{
  final User user;

  FriendsRemoved({required this.user});
}

class FriendsChanged extends FriendsEvent {
  final List<User> friends;

  FriendsChanged({required this.friends});
}
