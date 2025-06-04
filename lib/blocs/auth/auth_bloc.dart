import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repoositories.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      print('🟡 Bloc: LoginRequested');
      emit(const AuthLoading());

      try {
        final token = await authRepository.login(event.email, event.password);
        await authRepository.saveToken(token);
        print('🟢 Bloc: AuthSuccess');
        emit(AuthSuccess(token));
      } catch (e) {
        print('🔴 Bloc: AuthFailure - $e');
        emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<LogoutRequested>((event, emit) async {
      print('↩️ Bloc: LogoutRequested');
      await authRepository.logout();
      emit(const Unauthenticated());
    });

    on<AuthStatusChecked>((event, emit) async {
      print('🔍 Bloc: AuthStatusChecked');
      final token = await authRepository.getSavedToken();

      if (token != null && token.isNotEmpty) {
        print('🟢 Bloc: AuthStatusChecked → AuthSuccess');
        emit(AuthSuccess(token));
      } else {
        print('🔴 Bloc: AuthStatusChecked → Unauthenticated');
        emit(const Unauthenticated());
      }
    });
  }
}
