part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class MessageReceived extends MessageEvent {
  final types.Message message;

  MessageReceived({required this.message});
}
