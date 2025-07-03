import 'package:equatable/equatable.dart';

enum LoginState { Loading, Success, Failed }

class AuthState extends Equatable {
  final bool showpassword;
  final LoginState loginState;
  final String emsg;
  final bool isloading;
  const AuthState({
    this.loginState = LoginState.Loading,
    this.emsg = '',
    this.isloading = false,
    this.showpassword = true,
  });

  AuthState copyWith({
    LoginState? loginState,
    String? emsg,
    bool? showpassword, // ✅ consistent
    bool? isloading,
  }) {
    return AuthState(
      emsg: emsg ?? this.emsg,
      isloading: isloading ?? this.isloading,
      loginState: loginState ?? this.loginState,
      showpassword: showpassword ?? this.showpassword, // ✅ clear
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [loginState, emsg, isloading, showpassword];
}
