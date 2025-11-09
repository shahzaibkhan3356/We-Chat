import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignInPlatform.instance.signOut(const SignOutParams());
  }

  Future<void> signup(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> googleLogin() async {
    log("🚀 Starting Google Login Process");
    try {
      await GoogleSignInPlatform.instance.init(
        const InitParameters(
          serverClientId:
              "1033655241473-3ae8oiau8h463m10j434bu3vbdr5hb7n.apps.googleusercontent.com",
        ),
      );
      log("✅ GoogleSignInPlatform initialized");

      final AuthenticationResults result = await GoogleSignInPlatform.instance
          .authenticate(const AuthenticateParameters());
      log("✅ Authentication result received");

      final user = result.user;
      log("👤 Google user: ${user.email}");

      final tokens = await GoogleSignInPlatform.instance
          .clientAuthorizationTokensForScopes(
            ClientAuthorizationTokensForScopesParameters(
              request: AuthorizationRequestDetails(
                scopes: ['email', 'profile'],
                userId: user.id,
                email: user.email,
                promptIfUnauthorized: true,
              ),
            ),
          );

      if (tokens == null) {
        throw FirebaseAuthException(
          code: "token-error",
          message: "Failed to get Google access tokens.",
        );
      }

      log("🔑 AccessToken: ${tokens.accessToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: tokens.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      log("🎉 Firebase sign-in successful");
    } catch (e, st) {
      log("❌ Google login error: $e");
      log("Stacktrace: $st");
      rethrow;
    }
  }

  String getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'The email address format is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'The password entered is incorrect.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'operation-not-allowed':
        return 'This sign-in method is not allowed.';
      case 'weak-password':
        return 'Your password is too weak.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      case 'google-sign-in-failed':
        return 'Google Sign-In failed.';
      case 'token-error':
        return 'Couldn’t authenticate with Google.';
      default:
        return 'An unknown error occurred. Try again.';
    }
  }
}
