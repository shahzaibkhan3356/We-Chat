import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const Transition _transition = Transition.fade;

  static void goto(Widget Screen) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.to(Screen, transition: _transition);
  }

  static void Gofrom(Widget Screen) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.off(Screen, transition: _transition);
  }

  static void Gofromall(Widget Screen) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.offAll(Screen, transition: _transition);
  }

  static void Goback(Widget Screen) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.back();
  }
}
