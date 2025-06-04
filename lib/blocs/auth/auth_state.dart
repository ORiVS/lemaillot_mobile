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
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
  
}