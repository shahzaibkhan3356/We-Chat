import 'package:chat_app/Bloc/AuthBloc/auth_bloc.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_state.dart';
import 'package:chat_app/Presentation/Ui/Auth/Signup/SignupScreen.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/TextButton.dart';
import 'package:chat_app/Utils/NavigationService/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Utils/Constants/AppColors/appfonts.dart';
import '../../../../Utils/Constants/AppFonts/AppFonts.dart';
import '../../../Widgets/Buttons/CommonButton.dart';
import '../../../Widgets/Container/GlassContainer.dart';
import '../../../Widgets/TextInputWidget/TextInputWidget.dart';

class Forgotpasswordscreen extends StatelessWidget {
  const Forgotpasswordscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    final formKey = GlobalKey<FormState>();
    final email = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: GlassContainer(
          height: Get.height * 0.45,
          width: Get.width * 0.85,
          child: Form(
            key: formKey,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Reset Password",
                        style: AppFonts.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      AuthTextField(
                        focusNode: focusNode,
                        label: "Email",
                        hintText: "you@email.com",
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }
                          // Basic email format check
                          final emailRegex = RegExp(
                            r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$",
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        title: "Reset Password",
                        isloading: state.isloading,
                        ontap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (!state.isloading) {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                ResetPassword(email: email.text.trim()),
                              );
                            }
                          }
                        },
                      ),
                      Gap(10),
                      Center(
                        child: RichTextButton(
                          text: "Go Back To",
                          actionText: "Login",
                          onTap: () {
                            NavigationService.goto(SignupScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
