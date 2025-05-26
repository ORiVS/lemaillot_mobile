import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiServiceProvider));
});

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService api;

  AuthNotifier(this.api) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(error: null);
    try {
      final response = await api.login(email, password);
      state = state.copyWith(
        isAuthenticated: true,
        token: response['token'],
      );
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        error: e.toString(),
      );
    }
  }

  void logout() {
    state = AuthState();
  }
}
