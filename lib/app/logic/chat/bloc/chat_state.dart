part of 'chat_bloc.dart';

class ChatState {
  final List<types.Message> messages;

  ChatState({required this.messages});

  factory ChatState.initial() => ChatState(messages: []);

  ChatState copyWith({List<types.Message>? messages}) {
    return ChatState(messages: messages ?? this.messages);
  }
}
