import 'package:chat_app/Bloc/AuthBloc/auth_bloc.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_state.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/CommonButton.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/Googlebutton.dart';
import 'package:chat_app/Presentation/Widgets/Buttons/TextButton.dart';
import 'package:chat_app/Presentation/Widgets/TextInputWidget/TextInputWidget.dart';
import 'package:chat_app/Routes/route_names/routenames.dart';
import 'package:chat_app/Utils/Constants/AppFonts/AppFonts.dart';
import 'package:chat_app/Utils/NavigationService/navigation_service.dart';
import 'package:chat_app/services/SplashService/SplashService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' hide RiveAnimationController;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? _riveArtboard;
  SMIInput<bool>? _idle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SMIInput<bool>? _closeEyes;
  SMIInput<bool>? _isChecking;
  SMIInput<bool>? _trigSuccess;
  SMIInput<bool>? _trigFail;
  SMIInput<double>? _numLook;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/animated_login_character.riv').then((
      data,
    ) {
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: AppFonts.headingLarge,
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _loginSection(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GoogleLoginButton(
                onPressed: () {
                  context.read<AuthBloc>().add(Loginwithgoogle());
                },
              ),
            ),
          ],
        ),
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
            listenWhen: (previous, current) =>
                previous.loginState != current.loginState,
            listener: (context, state) {
              if (state.loginState == LoginState.Success) {
                _isChecking?.value = false;
                _trigSuccess?.value = true;
                Future.delayed(const Duration(seconds: 2), () {
                  SplashService.checkifuserexists();
                });
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
                          : const Center(
                              child: Text(
                                "The Bear is on his way ....",
                                style: AppFonts.body,
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.04,
                        vertical: Get.height * 0.03,
                      ),
                      child: InputFields(
                        keyboardType: TextInputType.emailAddress,
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
                        title: "Login",
                        ontap: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            _isChecking?.value = true;
                            context.read<AuthBloc>().add(
                              Loginwithemail(
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
                    if (!state.isloading) Gap(Get.height * 0.014),
                    ActionText(
                      text: "Forgot Password?",
                      actionText: "Reset Password",
                      onTap: () =>
                          NavigationService.goto(RouteNames.forgotpassword),
                    ),
                    Gap(Get.height * 0.015),
                    ActionText(
                      text: "Don't have an account?",
                      actionText: "Signup",
                      onTap: () => NavigationService.goto(RouteNames.signup),
                    ),
                    Gap(Get.height * 0.015),
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
