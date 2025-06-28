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

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Inscription réussie. Redirigez vers la vérification.');
        // Pas de token ici, la vérification sera faite après
        return;
      } else {
        throw Exception(response.data['detail'] ?? 'Erreur lors de l’inscription');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      print('❌ Inscription DioException: ${e.message}');
      print('❌ Données retournées : $data');

      if (data is Map && data.containsKey('detail')) {
        throw Exception(data['detail']);
      } else if (data is Map && data.isNotEmpty) {
        // Affiche les premières erreurs retournées par DRF
        final firstKey = data.keys.first;
        final firstError = data[firstKey];
        throw Exception('$firstKey: ${firstError[0]}');
      } else {
        throw Exception('Erreur réseau : ${e.message}');
      }
    } catch (e) {
      print('❌ Erreur inscription : $e');
      throw Exception('Erreur inattendue : $e');
    }
  }


  Future<String> verifyAccount(String email, String code) async {
    try {
      final response = await _dio.post(
        '/accounts/verify-code/',
        data: {
          'email': email,
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        // ✅ Lire le message
        final message = response.data['message'] ?? 'Compte activé avec succès.';
        return message;
      } else {
        throw Exception(response.data['detail'] ?? 'Échec de la vérification');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      print('❌ Erreur vérification Dio: ${e.message}');
      if (data is Map && data.containsKey('detail')) {
        throw Exception(data['detail']);
      } else {
        throw Exception('Erreur réseau : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue : $e');
    }
  }

  Future<void> resendCode(String email) async {
    try {
      final response = await _dio.post(
        '/accounts/resend-code/',
        data: {
          'email': email,
          'method': 'email', // méthode toujours "email"
        },
      );

      if (response.statusCode != 200) {
        throw Exception(response.data['detail'] ?? 'Erreur lors du renvoi du code');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      print('❌ Erreur renvoi code Dio: ${e.message}');
      throw Exception(data['detail'] ?? 'Erreur réseau : ${e.message}');
    }
  }
}
