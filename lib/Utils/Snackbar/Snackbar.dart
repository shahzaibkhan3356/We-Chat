import 'package:get/get.dart';

void showSnackbar(String title, String msg) {
  if (!Get.isSnackbarOpen) {
    Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);
  }
}
