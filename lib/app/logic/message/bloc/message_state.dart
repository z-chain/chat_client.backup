part of 'message_bloc.dart';

@immutable
class MessageState {
  final List<Message> messages;

  MessageState({required this.messages});

  factory MessageState.initial() => MessageState(messages: []);

  MessageState copyWith({List<Message>? messages}) {
    return MessageState(messages: messages ?? this.messages);
  }
}
