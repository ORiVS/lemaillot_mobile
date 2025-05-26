import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/accounts/login/', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['detail'] ?? 'Erreur lors de la connexion';
    }
  }

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data ?? 'Erreur lors du chargement des produits';
    }
  }

// TODO: Ajouter register, OTP, etc.
}
