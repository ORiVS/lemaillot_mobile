import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/accounts/login/',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final access = response.data['access'];
        final refresh = response.data['refresh'];

        if (access == null || refresh == null) {
          throw Exception('Tokens manquants dans la réponse');
        }

        await saveTokens(access, refresh);
        return access;
      } else {
        throw Exception(response.data['detail'] ?? 'Erreur inconnue');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      print('❌ DioException: statusCode=$statusCode');
      print('❌ Response data: $data');
      print('❌ Message: ${e.message}');

      if (data is Map && data.containsKey('detail')) {
        throw Exception(data['detail']);
      } else if (e.message != null) {
        throw Exception('Erreur réseau : ${e.message}');
      } else {
        throw Exception('Erreur inconnue');
      }
    } catch (e) {
      print('❌ Autre erreur : $e');
      throw Exception('Erreur inattendue : $e');
    }
  }

  Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<String?> refreshAccessToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return null;

    try {
      final response = await _dio.post(
        '/accounts/token/refresh/',
        data: {'refresh': refresh},
      );

      final newAccess = response.data['access'];
      if (newAccess != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', newAccess);
        return newAccess;
      }
    } catch (e) {
      print('❌ Erreur lors du refresh du token : $e');
    }

    return null;
  }
}
