import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirestoreRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _uid => _auth.currentUser!.uid;

  // ---------------------- USERS ----------------------

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('Users').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      log('Error getting all users: $e');
      rethrow;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('Users').doc(_uid).set(user.toMap());
    } catch (e) {
      log('Error creating user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final docSnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .get();
      if (docSnapshot.exists) {
        return UserModel.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      log('Error getting user: $e');
      rethrow;
    }
  }

  Stream<UserModel?> streamUser({String? uid}) {
    return _firestore.collection('Users').doc(uid ?? _uid).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('Users').doc(user.uid).update(user.toMap());
    } catch (e) {
      log('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await _firestore.collection('Users').doc(_uid).delete();
    } catch (e) {
      log('Error deleting user: $e');
      rethrow;
    }
  }

  // ---------------------- SUPABASE STORAGE ----------------------

  /// Uploads a profile picture to Supabase Storage and returns the public URL.
  Future<String?> uploadProfilePicture(String localFilePath) async {
    if (localFilePath.isEmpty) return null;
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    try {
      final file = File(localFilePath);
      final fileExt = localFilePath.split('.').last;
      final fileName = "${user.uid}_profile.$fileExt";

      // Upload to Supabase bucket
      final response = await _supabase.storage
          .from('media')
          .upload(
            'profile_pictures/$fileName',
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      if (response.isEmpty) {
        throw Exception("Upload failed: No response from Supabase");
      }

      // Get public URL
      final publicUrl = _supabase.storage
          .from('media')
          .getPublicUrl('profile_pictures/$fileName');

      // Update Firestore user doc
      await _firestore.collection('Users').doc(user.uid).update({
        'profilePic': publicUrl,
      });

      log("✅ Uploaded to Supabase: $publicUrl");
      return publicUrl;
    } catch (e) {
      log('❌ Error uploading profile picture: $e');
      rethrow;
    }
  }

  /// Gets the current user's profile picture URL (from Firestore).
  Future<String?> getProfilePictureUrl() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final docSnapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .get();
    if (docSnapshot.exists) {
      return docSnapshot.data()?['profilePic'] as String?;
    }
    return null;
  }

  /// Deletes profile picture from Supabase + clears Firestore field.
  Future<void> deleteProfilePicture() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final filePath = 'profile_pictures/${user.uid}_profile.jpg';
      await _supabase.storage.from('media').remove([filePath]);
      await _firestore.collection('Users').doc(user.uid).update({
        'profilePic': '',
      });

      log("🗑️ Deleted profile picture successfully");
    } catch (e) {
      log('⚠️ Error deleting profile picture: $e');
    }
  }

  // ---------------------- ERRORS ----------------------

  String getErrorMessage(e) {
    if (e is FirebaseException) {
      switch (e.code) {
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'user-not-found':
          return 'No user found for this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'The account already exists for that email.';
        case 'operation-not-allowed':
          return 'Email & Password sign-in is not enabled.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return 'An unknown Firebase error occurred.';
      }
    }
    return 'An unknown error occurred.';
  }
}
