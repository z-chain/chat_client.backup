part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatReceived extends ChatEvent {
  final types.Message message;

  ChatReceived({required this.message});
}

class ChatSent extends ChatEvent {
  final types.Message message;

  ChatSent({required this.message});
}
