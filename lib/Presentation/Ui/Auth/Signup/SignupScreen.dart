import 'package:chat_app/Bloc/AuthBloc/auth_bloc.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_state.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/CommonButton.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/TextButton.dart';
import 'package:chat_app/Presentation/Widgets/TextInputWidget/TextInputWidget.dart';
import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:chat_app/Utils/Constants/AppFonts/AppFonts.dart';
import 'package:chat_app/Utils/NavigationService/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0E0E0E),
      body: Stack(
        children: [
          // --- Background Gradient ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF121212),
                  Color(0xFF1E1E1E),
                  Color(0xFF0D0D0D),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // --- Glass Overlay ---
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              backgroundBlendMode: BlendMode.overlay,
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Title ---
                    Text(
                      "Create Account ✨",
                      style: AppFonts.headingLarge.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(height * 0.01),
                    Text(
                      "Sign up to start chatting on We-Chat",
                      style: AppFonts.body.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(height * 0.04),

                    // --- Glass Card Form ---
                    Card(
                      elevation: 12,
                      color: const Color(0xFF1C1C1C).withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.06,
                          vertical: height * 0.035,
                        ),
                        child: Form(
                          key: _formKey,
                          child: BlocListener<AuthBloc, AuthState>(
                            listenWhen: (prev, curr) =>
                                prev.loginState != curr.loginState,
                            listener: (context, state) {
                              if (state.loginState == LoginState.Success) {
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    NavigationService.Gofromall(
                                      RouteNames.home,
                                    );
                                  },
                                );
                              } else if (state.loginState ==
                                  LoginState.Failed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text("Signup Failed"),
                                  ),
                                );
                              }
                            },
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // --- Email Field ---
                                    InputFields(
                                      prefixIcon: Icons.email_outlined,
                                      label: 'Email',
                                      controller: _emailController,
                                      hintText: 'Enter your Email',
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Email is required';
                                        }
                                        final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                        );
                                        if (!emailRegex.hasMatch(
                                          value.trim(),
                                        )) {
                                          return 'Enter a valid email address';
                                        }
                                        return null;
                                      },
                                      focusNode: _emailFocusNode,
                                    ),
                                    Gap(height * 0.02),

                                    // --- Password Field ---
                                    InputFields(
                                      prefixIcon: Icons.password_outlined,
                                      label: 'Password',
                                      controller: _passwordController,
                                      hintText: 'Enter your Password',
                                      textInputAction: TextInputAction.done,
                                      isPassword: state.showpassword,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          context.read<AuthBloc>().add(
                                            Showorhidepass(
                                              value: state.showpassword,
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          state.showpassword
                                              ? CupertinoIcons.eye
                                              : CupertinoIcons.eye_fill,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password is required';
                                        }
                                        if (value.length < 6) {
                                          return 'Min 6 characters required';
                                        }
                                        return null;
                                      },
                                      focusNode: _passwordFocusNode,
                                    ),

                                    Gap(height * 0.035),

                                    // --- Signup Button ---
                                    CustomButton(
                                      title: "Sign Up",
                                      ontap: () {
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                            Signupwithemail(
                                              email: _emailController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                            ),
                                          );
                                        }
                                      },
                                      isloading: state.isloading,
                                    ),

                                    Gap(height * 0.025),
                                    ActionText(
                                      text: "Already have an account?",
                                      actionText: "Login",
                                      onTap: () {
                                        NavigationService.goto(
                                          RouteNames.login,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
