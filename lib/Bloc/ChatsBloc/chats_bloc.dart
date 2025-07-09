import 'dart:async';

import 'package:chat_app/Repository/ChatRepository/ChatRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Models/MessegeModel/MessegeModel.dart';
import 'chats_event.dart';
import 'chats_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  StreamSubscription<List<MessageModel>>? _messageStreamSub;

  ChatBloc(this.chatRepository) : super(const ChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<StartMessageStreamEvent>(_onStartStream);
    on<MarkMessageSeenEvent>(_onMarkSeen);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  void handleMessageUpdates(_ChatMessagesUpdated) {
    emit(state.copyWith(messages: _ChatMessagesUpdated));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isSending: true));
    try {
      await chatRepository.sendMessage(
        receiverId: event.receiverId,
        text: event.text,
        imageUrl: event.imageUrl,
      );
      emit(state.copyWith(isSending: false));
    } catch (e) {
      emit(
        state.copyWith(isSending: false, error: 'Failed to send message: $e'),
      );
    }
  }

  Future<void> _onStartStream(
    StartMessageStreamEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await _messageStreamSub?.cancel(); // cancel existing stream if active
    _messageStreamSub = chatRepository
        .getChatStream(receiverId: event.receiverId)
        .listen((messages) {
          add(_ChatMessagesUpdated(messages));
        });

    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onMarkSeen(
    MarkMessageSeenEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatRepository.markMessageAsSeen(
        receiverId: event.receiverId,
        messageId: event.messageId,
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to mark as seen: $e'));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await chatRepository.deleteMessage(
        receiverId: event.receiverId,
        messageId: event.messageId,
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete message: $e'));
    }
  }

  @override
  Future<void> close() {
    _messageStreamSub?.cancel();
    return super.close();
  }
}

// Internal event to emit new messages
class _ChatMessagesUpdated extends ChatEvent {
  final List<MessageModel> messages;

  const _ChatMessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}
