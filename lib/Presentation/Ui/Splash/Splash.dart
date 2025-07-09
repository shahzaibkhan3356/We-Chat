import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../Utils/Constants/AppColors/Appcolors.dart';
import '../../../Utils/Constants/AppFonts/AppFonts.dart';
import '../../../services/SplashService/SplashService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.1),
          child: Center(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        animate: true,
                        filterQuality: FilterQuality.high,
                        frameRate: FrameRate(60),
                        onLoaded: (p0) {
                          Future.delayed(const Duration(seconds: 3), () {
                            SplashService.checkAuthAndProfileStatus();
                          });
                        },
                        repeat: true,
                        'assets/animations/Splashanim.json',
                        height: Get.height * 0.3,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "We Chat",
                        style: AppFonts.headingLarge.copyWith(fontSize: 32),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Connect. Chat. Chill.",
                        style: AppFonts.hint.copyWith(fontSize: 16),
                      ),
                      Gap(Get.height * 0.08),
                      Lottie.asset(
                        animate: true,
                        filterQuality: FilterQuality.high,
                        frameRate: FrameRate(60),
                        height: 150,
                        width: 150,
                        // onLoaded: (p0) {
                        //   NavigationService.Gofromall(LoginScreen());
                        // },
                        repeat: true,
                        'assets/animations/loadinganim.json',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
