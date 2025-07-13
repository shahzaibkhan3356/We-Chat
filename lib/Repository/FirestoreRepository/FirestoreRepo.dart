import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Data/Models/Usermodel/Usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _uid => _auth.currentUser!.uid;
  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('Users').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      rethrow;
    }
  }

  // User CRUD
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('Users').doc(_uid).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser({String? uid}) async {
    try {
      final docSnapshot = await _firestore
          .collection('Users')
          .doc(uid ?? _uid)
          .get();
      if (docSnapshot.exists) {
        return UserModel.fromMap(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }
  Stream<UserModel?> streamUser({String? uid}) {
    return _firestore.collection('Users').doc(uid ?? _uid).snapshots().map(
          (doc) {
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!, doc.id);
        }
        return null;
      },
    );
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('Users').doc(user.uid).update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await _firestore.collection('Users').doc(_uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
  Future<String?> uploadProfilePicture(String localFilePath) async {
    if (localFilePath.isEmpty) return null;
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user logged in");

    try {
      File file = File(localFilePath);
      Reference ref = _storage.ref().child('profile_pictures').child(user.uid);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log('Error uploading profile picture: $e');
      rethrow;
    }
  }

  Future<String?> getProfilePictureUrl() async {
      final User = _auth.currentUser;
      if (User == null) return null;
      final docSnapshot =
      await _firestore.collection('Users').doc(User.uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return data?['profilePic'] as String?;
      }
  }

  Future<void> deleteProfilePicture() async {
    try {
      // Create a reference to the file to delete
      Reference ref = _storage.ref().child('profile_pictures').child(_uid);

      // Delete the file
      await ref.delete();

      // Update the user's profilePic URL in Firestore to be empty
      await _firestore.collection('Users').doc(_uid).update({'profilePic': ''});
    } catch (e) {
      // It's possible the file doesn't exist, so we can ignore that error.
      if (e is FirebaseException && e.code == 'object-not-found') {
        print('Profile picture not found, no need to delete.');
        // Still update firestore
        await _firestore.collection('Users').doc(_uid).update({
          'profilePic': '',
        });
      } else {
        print('Error deleting profile picture: $e');
        rethrow;
      }
    }
  }


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
          return 'An unknown error occurred.';
      }
    }
    return 'An unknown error occurred.';
  }
}
