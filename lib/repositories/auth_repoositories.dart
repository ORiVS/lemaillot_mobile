import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

  Future<String> login(String email, String password) async {
    print('📤 Tentative de connexion : $email');
    print('🔗 Endpoint : ${_dio.options.baseUrl}/accounts/login/');

    try {
      final response = await _dio.post(
        '/accounts/login/',
        data: {'email': email, 'password': password},
      );

      print('✅ Réponse statusCode : ${response.statusCode}');
      print('✅ Réponse data : ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['access'];
        if (token == null) throw Exception('Token manquant');
        print('🛡️ Token reçu : $token');
        return token;
      } else {
        throw Exception(response.data['detail'] ?? 'Erreur inconnue');
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      print('🛑 Erreur API - status: $status | data: $data');

      String message = 'Erreur inconnue';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      } else if (data is String) {
        message = data;
      } else if (e.message != null) {
        message = e.message!;
      }

      throw Exception(message);
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    print('💾 Token sauvegardé localement');
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print('🔍 Token trouvé en cache : $token');
    return token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    print('🧹 Token supprimé (logout)');
  }
}
