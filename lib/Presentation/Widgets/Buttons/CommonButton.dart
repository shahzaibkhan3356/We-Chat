import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../Utils/Constants/AppColors/Appcolors.dart';
import '../../../Utils/Constants/AppFonts/AppFonts.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool isloading;
  const CustomButton({
    super.key,
    required this.title,
    required this.ontap,
    required this.isloading,
  });

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Lottie.asset(
        animate: true,
        filterQuality: FilterQuality.high,
        frameRate: FrameRate(60),
        height: 60,
        width: 180,
        repeat: true,
        'assets/animations/loadinganim.json',
      );
    }
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: ontap,
        child: Text(title, style: AppFonts.button),
      ),
    );
  }
}
