import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../Utils/Constants/AppColors/appfonts.dart';
import '../../../Utils/Constants/AppFonts/AppFonts.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool isloading;
  const AuthButton({
    super.key,
    required this.title,
    required this.ontap,
    required this.isloading
  });

  @override
  Widget build(BuildContext context) {
    if(isloading){
      return  Lottie.asset(
        animate: true,
        filterQuality: FilterQuality.high,
        frameRate: FrameRate(60),
        height: 80,
        width: 80,
        // onLoaded: (p0) {
        //   NavigationService.Gofromall(LoginScreen());
        // },
        repeat: true,
        'assets/animations/loadinganim.json',
      );
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: ontap,
      child: Text(title,style: AppFonts.button,),
    );
  }
}
