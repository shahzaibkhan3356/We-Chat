import 'package:chat_app/Utils/NavigationService/navigation_service.dart';
import 'package:chat_app/routes/routes_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
Future<void> logout() async {
   await _auth.signOut();
   NavigationService.Gofromall(AppRoutes.login);
}
  Future<void> signup(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> googleLogin() async {
    await GoogleSignInPlatform.instance.init(const InitParameters());

    final AuthenticationResults result =
    await GoogleSignInPlatform.instance.authenticate(
      const AuthenticateParameters(),
    );

    final user = result.user;
    final tokens = await GoogleSignInPlatform.instance
        .clientAuthorizationTokensForScopes(
      ClientAuthorizationTokensForScopesParameters(
        request: AuthorizationRequestDetails(
          scopes: ['email', 'profile'],
          userId: user.id,
          email: user.email,
          promptIfUnauthorized: false,
        ),
      ),
    );

    if (tokens == null) {
      throw FirebaseAuthException(
        code: "token-error",
        message: "Failed to get Google access tokens.",
      );
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: tokens.accessToken,
    );

    await _auth.signInWithCredential(credential);
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
