import 'package:equatable/equatable.dart';

import '../../Data/Models/MessegeModel/MessegeModel.dart';

class ChatState extends Equatable {
  final List<MessageModel> messages;
  final bool isSending;
  final bool isLoading;
  final String error;

  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.isLoading = false,
    this.error = '',
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isSending,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [messages, isSending, isLoading, error];
}
