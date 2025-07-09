import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String receiverId;
  final String text;
  final String? imageUrl;

  const SendMessageEvent({
    required this.receiverId,
    required this.text,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [receiverId, text, imageUrl];
}

class StartMessageStreamEvent extends ChatEvent {
  final String receiverId;

  const StartMessageStreamEvent({required this.receiverId});

  @override
  List<Object?> get props => [receiverId];
}

class MarkMessageSeenEvent extends ChatEvent {
  final String receiverId;
  final String messageId;

  const MarkMessageSeenEvent({
    required this.receiverId,
    required this.messageId,
  });

  @override
  List<Object?> get props => [receiverId, messageId];
}

class DeleteMessageEvent extends ChatEvent {
  final String receiverId;
  final String messageId;

  const DeleteMessageEvent({required this.receiverId, required this.messageId});

  @override
  List<Object?> get props => [receiverId, messageId];
}
