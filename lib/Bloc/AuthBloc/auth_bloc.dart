import 'package:chat_app/Bloc/AuthBloc/auth_event.dart';
import 'package:chat_app/Bloc/AuthBloc/auth_state.dart';
import 'package:chat_app/Repository/AuthRepository/AuthRepository.dart';
import 'package:chat_app/Utils/Snackbar/Snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Routes/route_names/routenames.dart';
import '../../Utils/NavigationService/navigation_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc(this.authRepo) : super(const AuthState()) {
    on<Loginwithemail>(_onLoginWithEmail);
    on<Signupwithemail>(_onSignupWithEmail);
    on<Showorhidepass>(_onShowOrHidePass);
    on<ResetPassword>(_onResetPassword);
    on<Logout>(_onlogout);
    on<Loginwithgoogle>(_onloginwithgoogle);
  }

  void _onShowOrHidePass(Showorhidepass event, Emitter<AuthState> emit) {
    emit(state.copyWith(showpassword: !event.value));
  }

  Future<void> _onloginwithgoogle(
    Loginwithgoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));

    try {
      await authRepo.googleLogin();
      showSnackbar("Login", "Logged in Successfully");
      emit(state.copyWith(isloading: false, loginState: LoginState.Success));
      Future.delayed(const Duration(seconds: 2));
    } on FirebaseAuthException catch (e) {
      final message = authRepo.getAuthErrorMessage(e.code);
      showSnackbar("Login Error", message);
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    } catch (e) {
      showSnackbar("Login Error", e.toString());
      print(e);
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    }
  }

  Future<void> _onlogout(
      Logout event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));

    try {
      await authRepo.logout();
      showSnackbar("Logout", "Logged Out Successfully");
      NavigationService.Gofromall(RouteNames.login);
    } on FirebaseAuthException catch (e) {
      final message = authRepo.getAuthErrorMessage(e.code);
      showSnackbar("Logout Error", message);
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    } catch (e) {
      showSnackbar("Logout Error", e.toString());
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    }
  }
  Future<void> _onLoginWithEmail(
    Loginwithemail event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));

    try {
      await authRepo.loginWithEmail(event.email, event.password);
      showSnackbar("Login", "Logged in Successfully");
      emit(state.copyWith(isloading: false, loginState: LoginState.Success));
      Future.delayed(const Duration(seconds: 2));
    } on FirebaseAuthException catch (e) {
      final message = authRepo.getAuthErrorMessage(e.code);
      showSnackbar("Login Error", message);
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    } catch (e) {
      showSnackbar("Login Error", e.toString());
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    }
  }

  Future<void> _onSignupWithEmail(
    Signupwithemail event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));

    try {
      await authRepo.signup(event.email, event.password);
      showSnackbar("Sign Up", "Account Created Successfully");
      emit(state.copyWith(isloading: false, loginState: LoginState.Success));
      Future.delayed(const Duration(seconds: 2));
    } on FirebaseAuthException catch (e) {
      final message = authRepo.getAuthErrorMessage(e.code);
      showSnackbar("Sign Up Error", message);
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    } catch (_) {
      showSnackbar("Sign Up Error", "Something went wrong. Please try again.");
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isloading: true, loginState: LoginState.Loading));

    try {
      await authRepo.resetPassword(event.email);
      showSnackbar(
        "Reset Password",
        "Check your email to reset your password.",
      );
      emit(state.copyWith(isloading: false, loginState: LoginState.Success));
    } on FirebaseAuthException catch (e) {
      final message = authRepo.getAuthErrorMessage(e.code);
      showSnackbar("Reset Error", message);
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    } catch (_) {
      showSnackbar("Reset Error", "Something went wrong. Please try again.");
      emit(state.copyWith(isloading: false, loginState: LoginState.Failed));
    }
  }
}
