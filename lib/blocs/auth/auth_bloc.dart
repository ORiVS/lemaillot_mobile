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
        emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
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
  }
}
