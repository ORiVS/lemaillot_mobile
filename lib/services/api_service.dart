import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

Future<Map<String, dynamic>> login(String email, String password) async {
  print(' Tentative de login avec :');
  print('  Email : $email');
  print('  Password : $password');
  print('  URL de base : ${dotenv.env['API_URL']}');

  try { 
    final response = await _dio.post('/accounts/login/', data: {
      'email': email,
      'password': password,
    });

    print(' Réponse API : ${response.statusCode}');
    print(' Données : ${response.data}');
    return response.data;
  } on DioException catch (e) {
    print(' DioException : ${e.response?.statusCode} - ${e.response?.data}');
    print(' Message : ${e.message}');
    throw e.response?.data.toString() ?? 'Erreur lors de la connexion';

  } catch (e) {
    print(' Autre erreur : $e');
    throw 'Erreur inconnue';
  }
}
}