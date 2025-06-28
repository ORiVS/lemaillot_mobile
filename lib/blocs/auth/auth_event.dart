import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();

}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();

}

class RegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String phonenumber;

  RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.phonenumber

  });
}

class VerifyRequested extends AuthEvent {
  final String email;
  final String code;

  VerifyRequested({
    required this.email,
    required this.code,
  });
}

class ResendCodeRequested extends AuthEvent {
  final String email;

  const ResendCodeRequested({required this.email});
}

