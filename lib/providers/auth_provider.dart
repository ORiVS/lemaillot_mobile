import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthState {
  final bool isAuthenticated;
  final String? error;
  final String? token;

  AuthState({this.isAuthenticated = false, this.error, this.token});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;

  AuthNotifier(this._apiService) : super(AuthState());

Future<void> login(String email, String password) async {
  print('📡 Appel à login() de AuthNotifier');
  try {
    final data = await _apiService.login(email, password);
    print('✅ Données reçues dans AuthNotifier : $data');

    final access = data['access'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    print('✅ Token sauvegardé dans SharedPreferences : $access');

    state = AuthState(isAuthenticated: true, token: access);
  } catch (e) {
    print('❌ Erreur dans AuthNotifier : $e');
    state = AuthState(error: e.toString());
  }
}

}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(apiServiceProvider)),
);
