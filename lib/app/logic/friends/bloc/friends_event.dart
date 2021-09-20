part of 'friends_bloc.dart';

@immutable
abstract class FriendsEvent {}

class FriendsAdded extends FriendsEvent {
  final Friend friend;

  FriendsAdded({required this.friend});
}

class FriendsRemoved extends FriendsEvent{
  final Friend friend;

  FriendsRemoved({required this.friend});
}

class FriendsChanged extends FriendsEvent {
  final List<Friend> friends;

  FriendsChanged({required this.friends});
}
