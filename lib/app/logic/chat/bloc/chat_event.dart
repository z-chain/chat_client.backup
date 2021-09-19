part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatSent extends ChatEvent {
  final types.Message message;

  ChatSent({required this.message});
}
