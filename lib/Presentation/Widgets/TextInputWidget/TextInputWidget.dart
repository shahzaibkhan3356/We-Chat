import 'package:flutter/material.dart';

import '../../../Utils/Constants/AppColors/Appcolors.dart';
import '../../../Utils/Constants/AppFonts/AppFonts.dart';

class InputFields extends StatelessWidget {
  final String label;
  final String hintText;

  final FocusNode? focusNode;
  final bool isPassword;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final TextInputAction textInputAction; // Add this property

  const InputFields({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.validator,

    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction = TextInputAction.done, // Default to done
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.body.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(

          textInputAction: textInputAction, // Use the new property
          controller: controller,
          validator: validator,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: AppFonts.body,
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppFonts.hint,
            filled: true,
            fillColor: Colors.white10,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.orange)
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            errorStyle: AppFonts.hint.copyWith(
              color: Colors.redAccent,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}