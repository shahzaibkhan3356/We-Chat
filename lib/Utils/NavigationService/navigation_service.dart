import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static void goto(String routename) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(routename);
  }

  static void Gofrom(String routename) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.offNamed(routename);
  }

  static void Gofromall(String routename) {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.offAllNamed(routename);
  }

  static void Goback() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.back();
  }
}
