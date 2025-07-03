import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_state.dart';
import 'package:chat_app/Presentation/Ui/Auth/Login/LoginScreen.dart';
import 'package:chat_app/Presentation/Ui/Home/HomeScreen.dart';
import 'package:chat_app/Presentation/Ui/Profile/ProfileSetup/SetupProfile.dart';
import 'package:chat_app/Repository/AuthRepository/AuthRepository.dart';
import 'package:chat_app/Utils/NavigationService/navigation_service.dart';
import 'package:chat_app/Utils/Snackbar/Snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc(this.authRepo) : super(AuthState()) {
    on<Loginwithemail>(_onLoginWithEmail);
    on<Signupwithemail>(_onSignupWithEmail);
    on<Showorhidepass>(_onShowOrHidePass);
    on<ResetPassword>(_onresetpasswoprd);
  }

  void _onShowOrHidePass(Showorhidepass event, Emitter<AuthState> emit) {
    emit(state.copyWith(showpassword: !event.value));
  }

  Future<void> _onLoginWithEmail(
    Loginwithemail event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));
    try {
      await authRepo.loginWithEmail(event.email, event.password);
      emit(state.copyWith(isloading: false, loginState: LoginState.Success));
      showSnackbar("Login", "Logged in Successfully");
      NavigationService.Gofromall(Homescreen());
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
      showSnackbar("Login Error", authRepo.getAuthErrorMessage(e.code));
    }
  }

  Future<void> _onresetpasswoprd(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));

    try {
      await authRepo.resetPassword(event.email);
      emit(state.copyWith(isloading: false, loginState: LoginState.Success));
      NavigationService.Gofrom(LoginScreen());
      showSnackbar(
        "Reset Password",
        "An Email for Password Reset has been sent to your Email",
      );
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
      showSnackbar(
        "Password Reset Error",
        authRepo.getAuthErrorMessage(e.code),
      );
    }
  }

  Future<void> _onSignupWithEmail(
    Signupwithemail event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));

    try {
      await authRepo.signup(event.email, event.password);
      emit(state.copyWith(isloading: false, loginState: LoginState.Success));
      showSnackbar("Sign up", "Account Created Successfully");
      NavigationService.Gofromall(ProfileSetupScreen());
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
      showSnackbar("Sign up Error", authRepo.getAuthErrorMessage(e.code));
    }
  }
}
