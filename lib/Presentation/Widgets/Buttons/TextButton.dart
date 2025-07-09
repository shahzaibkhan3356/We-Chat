import 'package:chat_app/Utils/Constants/AppFonts/AppFonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionText extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final TextStyle? actionStyle;

  const ActionText({
    Key? key,
    required this.text,
    required this.actionText,
    required this.onTap,
    this.textStyle,
    this.actionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: text,
          style:
              textStyle ??
              AppFonts.body.copyWith(
                color: Colors.grey,
                fontSize: Get.width * 0.04,
              ),
          children: [
            TextSpan(
              text: ' $actionText',
              style:
                  actionStyle ??
                  AppFonts.body.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.041,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
