import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/auth_guard.dart';
import 'dio_client.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/accounts/login/',
        data: {'email': email, 'password': password},
      );

      final access = response.data['access'];
      final refresh = response.data['refresh'];

      if (access == null || refresh == null) {
        throw Exception('Tokens manquants dans la réponse');
      }

      await saveTokens(access, refresh);
      return access;
    } on DioException catch (e) {
      print('❌ Login DioException: ${e.message}');
      throw Exception(parseApiError(e));
    } catch (e) {
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

  Future<void> register(
      String firstName,
      String lastName,
      String email,
      String username,
      String password,
      String phoneNumber,
      ) async {
    try {
      final response = await _dio.post(
        '/accounts/registerUser/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
        },
      );

      print('✅ Inscription réussie');
    } on DioException catch (e) {
      print('❌ Register DioException: ${e.message}');
      throw Exception(parseApiError(e));
    } catch (e) {
      throw Exception('Erreur inattendue : $e');
    }
  }

  Future<String> verifyAccount(String email, String code) async {
    try {
      final response = await _dio.post(
        '/accounts/verify-code/',
        data: {'email': email, 'code': code},
      );

      return response.data['message'] ?? 'Compte activé avec succès.';
    } on DioException catch (e) {
      print('❌ Vérification DioException: ${e.message}');
      throw Exception(parseApiError(e));
    } catch (e) {
      throw Exception('Erreur inattendue : $e');
    }
  }

  Future<void> resendCode(String email) async {
    try {
      final dio = DioClient.createDio(withAuth: false);

      await dio.post(
        '/accounts/resend-code/',
        data: {'email': email, 'method': 'email'},
      );
    } on DioException catch (e) {
      print('❌ Resend DioException: ${e.message}');
      throw Exception(parseApiError(e));
    } catch (e) {
      throw Exception('Erreur inattendue : $e');
    }
  }
}
