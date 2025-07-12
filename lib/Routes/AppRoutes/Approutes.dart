// lib/app/routes/app_pages.dart
import 'package:chat_app/Presentation/Ui/Auth/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:chat_app/Presentation/Ui/Auth/Login/LoginScreen.dart';
import 'package:chat_app/Presentation/Ui/Auth/Signup/SignupScreen.dart';
import 'package:chat_app/Presentation/Ui/Home/HomeScreen.dart';
import 'package:chat_app/Presentation/Ui/Profile/ProfileSetup/SetupProfile.dart';
import 'package:chat_app/Presentation/Ui/Splash/Splash.dart';
import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:get/get.dart';

class AppPages {
  Transition defaultTransition = Transition.fade;
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.profilesetup,
      page: () => const ProfileSetupScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const Homescreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.forgotpassword,
      page: () => const Forgotpasswordscreen(),
      transition: Transition.fade,
    ),
  ];
}
