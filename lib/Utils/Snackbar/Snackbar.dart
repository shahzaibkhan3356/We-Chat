import 'package:get/get.dart';

void showSnackbar(String title,String msg){
   Get.snackbar(title, msg,snackPosition: SnackPosition.BOTTOM);
}