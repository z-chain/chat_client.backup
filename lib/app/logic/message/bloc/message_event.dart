part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class MessageReceived extends MessageEvent {
  final User user;

  final types.Message? message;

  MessageReceived({required this.user, this.message});
}
