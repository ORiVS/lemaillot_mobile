import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();


}

class AuthLoading extends AuthState {
  const AuthLoading();

}

class AuthSuccess extends AuthState {
  final String token;

  const AuthSuccess(this.token);

  @override
  List<Object?> get props => [token];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}


class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthVerificationSuccess extends AuthState {
  final String message;
  const AuthVerificationSuccess(this.message);
}

class AuthNeedsVerification extends AuthState {
  final String email;

  const AuthNeedsVerification(this.email);

  @override
  List<Object> get props => [email];
}
