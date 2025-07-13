// lib/app/routes/app_pages.dart
import 'package:chat_app/Presentation/Ui/Auth/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:chat_app/Presentation/Ui/Auth/Login/LoginScreen.dart';
import 'package:chat_app/Presentation/Ui/Auth/Signup/SignupScreen.dart';
import 'package:chat_app/Presentation/Ui/Home/HomeScreen.dart';
import 'package:chat_app/Presentation/Ui/Profile/ProfilePage/ProfilePage.dart';
import 'package:chat_app/Presentation/Ui/Profile/ProfileSetup/SetupProfile.dart';
import 'package:chat_app/Presentation/Ui/Splash/Splash.dart';
import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:get/get.dart';

class AppPages {
  Transition defaultTransition = Transition.fade;
  static final routes = [
    GetPage(
      name: RouteNames.login,
      page: () => const LoginScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.signup,
      page: () => const SignupScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.profilesetup,
      page: () => const ProfileSetupScreen(),
    ),
    GetPage(
      name: RouteNames.home,
      page: () => const Homescreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.forgotpassword,
      page: () => const Forgotpasswordscreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: RouteNames.Profile,
      page: () => const Profilepage(),
      transition: Transition.fade,
    ),
  ];
}
