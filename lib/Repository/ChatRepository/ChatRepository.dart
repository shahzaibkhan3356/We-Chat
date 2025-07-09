import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Data/Models/MessegeModel/MessegeModel.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser!.uid;

  // 🔴 1. Send a message
  Future<void> sendMessage({
    required String receiverId,
    required String text,
    String? imageUrl,
  }) async {
    final String chatId = _getChatId(_currentUserId, receiverId);
    final String messageId = _firestore.collection('Chats').doc().id;
    final message = MessageModel(
      id: messageId,
      senderId: _currentUserId,
      receiverId: receiverId,
      text: text,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
      isSeen: false,
    );

    final messageMap = message.toMap();

    await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set(messageMap);
  }

  // 🔵 2. Get chat messages stream
  Stream<List<MessageModel>> getChatStream({required String receiverId}) {
    final String chatId = _getChatId(_currentUserId, receiverId);

    return _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // 🟢 3. Mark a message as seen
  Future<void> markMessageAsSeen({
    required String receiverId,
    required String messageId,
  }) async {
    final chatId = _getChatId(_currentUserId, receiverId);
    await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isSeen': true});
  }

  // 🟡 4. Delete a message
  Future<void> deleteMessage({
    required String receiverId,
    required String messageId,
  }) async {
    final chatId = _getChatId(_currentUserId, receiverId);
    await _firestore
        .collection('Chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  // 🔁 Utility method
  String _getChatId(String user1, String user2) {
    return (user1.compareTo(user2) < 0) ? '${user1}_$user2' : '${user2}_$user1';
  }
}
