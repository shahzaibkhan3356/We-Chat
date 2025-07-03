import 'package:chat_app/Bloc/AuthBloc/auth_bloc.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_state.dart';
import 'package:chat_app/Presentation/Ui/Auth/ForgotPassword/ForgotPasswordScreen.dart';
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
import '../../../Widgets/Buttons/Googlebutton.dart';
import '../../../Widgets/Container/GlassContainer.dart';
import '../../../Widgets/TextInputWidget/TextInputWidget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _email = TextEditingController();
  final _password = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: GlassContainer(
          height: Get.height * 0.7,
          width: Get.width * 0.85,
          child: Form(
            key: _formKey,
            child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Login",
                    style: AppFonts.headingLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  AuthTextField(
                    focusNode: focusNode,
                    label: "Email",
                    hintText: "you@email.com",
                    controller: _email,
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
                  AuthTextField(
                    focusNode: focusNode,
                    suffixIcon: IconButton(onPressed: () {
                      context.read<AuthBloc>().add(Showorhidepass(value: state.showpassword));
                    }, icon: Icon(state.showpassword ? Icons.remove_red_eye :Icons.remove_red_eye_outlined,color: state.showpassword ? Colors.grey : Colors.blue )),
                    label: "Password",
                    hintText: "Enter password",
                    controller: _password,
                    isPassword: state.showpassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Password should be at least 6 characters";
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Password must contain at least one uppercase letter";
                      }
                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return "Password must contain at least one lowercase letter";
                      }
                      if (!RegExp(r'\d').hasMatch(value)) {
                        return "Password must contain at least one number";
                      }
                      if (!RegExp(r'[!@#$&*~_.,;:^%()-]').hasMatch(value)) {
                        return "Password must contain at least one special character";
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock,
                  ),

                  const SizedBox(height: 25),
                  AuthButton(title: "Login",isloading: state.isloading, ontap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
           if(!state.isloading){
             if (_formKey.currentState!.validate()) {
               context.read<AuthBloc>().add(Loginwithemail(
                 email: _email.text.trim(),
                 password: _password.text.trim(),
               ));
             }
           }
                  }),
                  Gap(20),
                  Center(
                    child: RichTextButton(text: "Dont Have an Acount",actionText: "Signup",onTap: () {
NavigationService.goto(SignupScreen());
                    },),
                  ),
                  Gap(10),
                  Center(
                    child: RichTextButton(text: "Forgot Password",actionText: "Click Here",onTap: () {
                      NavigationService.goto(Forgotpasswordscreen());
                    },),
                  ),
                  // GoogleLoginButton(onPressed: () {
                  //
                  // }),

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
