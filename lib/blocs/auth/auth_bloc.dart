import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repoositories.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(const AuthLoading());
      try {
        final token = await authRepository.login(event.email, event.password);
        emit(AuthSuccess(token));
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(const Unauthenticated());
    });

    on<AuthStatusChecked>((event, emit) async {
      final token = await authRepository.getSavedToken();

      if (token != null && token.isNotEmpty) {
        emit(AuthSuccess(token));
      } else {
        final newToken = await authRepository.refreshAccessToken();
        if (newToken != null) {
          emit(AuthSuccess(newToken));
        } else {
          emit(const Unauthenticated());
        }
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(const AuthLoading());
      try {
        await authRepository.register(
          event.firstName,
          event.lastName,
          event.email,
          event.username,
          event.password,
          event.phonenumber,
        );
        emit(AuthNeedsVerification(event.email));
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceAll('Exception: ', '')));
      }
    });


    on<VerifyRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final message = await authRepository.verifyAccount(event.email, event.code);
        emit(AuthVerificationSuccess(message));
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceAll('Exception: ', '')));
      }
    });


    on<ResendCodeRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.resendCode(event.email);
        emit(const AuthCodeResent());
      } catch (e) {
        emit(AuthFailure(error: e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
class AuthCodeResent extends AuthState {
  const AuthCodeResent();
}

