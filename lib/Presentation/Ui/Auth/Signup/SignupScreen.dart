import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../../../../Bloc/AuthBloc/auth_bloc.dart';
import '../../../../Bloc/AuthBloc/auth_state.dart';
import '../../../../Utils/Constants/AppFonts/AppFonts.dart';
import '../../../../Utils/NavigationService/navigation_service.dart';
import '../../../Widgets/Buttons/CommonButton.dart';
import '../../../Widgets/Buttons/TextButton.dart';
import '../../../Widgets/TextInputWidget/TextInputWidget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Artboard? _riveArtboard;

  SMIInput<bool>? _idle;
  SMIInput<bool>? _closeEyes;
  SMIInput<bool>? _isChecking;
  SMIInput<bool>? _trigSuccess;
  SMIInput<bool>? _trigFail;
  SMIInput<double>? _numLook;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/animated_login.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(
        artboard,
        'Login Machine',
      );
      if (controller != null) {
        artboard.addController(controller);
        _idle = controller.findInput('idle');
        _closeEyes = controller.findInput('isHandsUp');
        _isChecking = controller.findInput('isChecking');
        _trigSuccess = controller.findInput('trigSuccess');
        _trigFail = controller.findInput('trigFail');
        _numLook = controller.findInput('numLook');
      }
      setState(() {
        _riveArtboard = artboard;
        _idle?.value = true;
      });
    });

    _emailController = TextEditingController()..addListener(_emailListener);
    _passwordController = TextEditingController()
      ..addListener(_passwordListener);

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.removeListener(_emailListener);
    _emailController.dispose();
    _passwordController.removeListener(_passwordListener);
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: AppFonts.headingLarge,
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [_loginSection(context)]),
      ),
    );
  }

  Widget _loginSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      child: Card(
        child: Form(
          key: _formKey,
          child: BlocListener<AuthBloc, AuthState>(
            listenWhen: (prev, curr) => prev.loginState != curr.loginState,
            listener: (context, state) {
              if (state.loginState == LoginState.Success) {
                _isChecking?.value = false;
                _trigSuccess?.value = true;
              } else if (state.loginState == LoginState.Failed) {
                _isChecking?.value = false;
                _trigFail?.value = true;
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(
                      height: _riveArtboard != null
                          ? Get.height * 0.28
                          : Get.height * 0.25,
                      child: _riveArtboard != null
                          ? Rive(artboard: _riveArtboard!)
                          : Center(
                              child: Text(
                                "The Bear is on his way ....",
                                style: AppFonts.body,
                              ),
                            ),
                    ),
                    Gap(Get.height * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.04,
                      ),
                      child: InputFields(
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        label: 'Email',
                        controller: _emailController,
                        hintText: 'Enter your Email',
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocusNode,
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          _isChecking?.value = false;
                          _closeEyes?.value = true;
                        } else {
                          _closeEyes?.value = false;
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.04,
                        ),
                        child: InputFields(
                          suffixIcon: IconButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                Showorhidepass(value: state.showpassword),
                              );
                            },
                            icon: Icon(
                              state.showpassword
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_fill,
                            ),
                          ),
                          prefixIcon: Icons.password_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password is required';
                            }
                            if (value.trim().length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          label: 'Password',
                          controller: _passwordController,
                          hintText: 'Enter your Password',
                          isPassword: state.showpassword,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocusNode,
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: CustomButton(
                        title: "Sign Up",
                        ontap: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            _isChecking?.value = true;
                            context.read<AuthBloc>().add(
                              Signupwithemail(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                          } else {
                            _isChecking?.value = false;
                            _trigFail?.value = true;
                          }
                        },
                        isloading: state.isloading,
                      ),
                    ),
                    if (!state.isloading) Gap(Get.height * 0.025),
                    ActionText(
                      text: "Already Have a Acount ?",
                      actionText: "Login",
                      onTap: () {
                        NavigationService.goto(AppRoutes.login);
                      },
                    ),
                    Gap(Get.height * 0.04),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _emailListener() {
    _numLook?.value = _emailController.text.trim().length.toDouble();
  }

  void _passwordListener() {
    _numLook?.value = 0;
  }
}
