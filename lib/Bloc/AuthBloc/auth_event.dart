import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loginwithemail extends AuthEvent {
  final String email;
  final String password;
  const Loginwithemail({required this.email, required this.password});
  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

class Showorhidepass extends AuthEvent {
  final bool value;
  const Showorhidepass({required this.value});
  @override
  // TODO: implement props
  List<Object?> get props => [value];
}

class Signupwithemail extends AuthEvent {
  final String email;
  final String password;
  const Signupwithemail({required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}
class Logout extends AuthEvent {}
class Loginwithgoogle extends AuthEvent {}

class ResetPassword extends AuthEvent {
  final String email;
  const ResetPassword({required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [email];
}
