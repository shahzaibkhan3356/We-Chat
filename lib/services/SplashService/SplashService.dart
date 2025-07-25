import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:chat_app/Utils/NavigationService/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Call this in splash screen to check login & profile status
  static Future<void> checkifuserexists() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      // Not logged in
      NavigationService.Gofromall(RouteNames.login);
      return;
    }
    try {
      final userDoc = await _firestore
          .collection("Users")
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!.isNotEmpty) {
        // Profile exists
        NavigationService.Gofromall(RouteNames.home);
      } else {
        // Logged in but profile missing
        NavigationService.Gofromall(RouteNames.profilesetup);
      }
    } catch (e) {
      print("Error in SplashService: $e");
    }
  }

  /// Call this in splash screen to check login & profile status
  static Future<void> checkAuthAndProfileStatus() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      // Not logged in
      NavigationService.Gofromall(RouteNames.login);
      return;
    }

    try {
      final userDoc = await _firestore
          .collection("Users")
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!.isNotEmpty) {
        // Profile exists
        NavigationService.Gofromall(RouteNames.home);
      } else {
        // Logged in but profile missing
        NavigationService.Gofromall(RouteNames.profilesetup);
      }
    } catch (e) {
      print("Error in SplashService: $e");
      NavigationService.Gofromall(RouteNames.login);
    }
  }
}
