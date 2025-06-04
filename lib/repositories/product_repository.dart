import 'package:dio/dio.dart';
import '../models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await _dio.get('/api/store/products/');
      print('📦 Requête produits envoyée, status : ${response.statusCode}');
      print('📦 Données reçues : ${response.data}');

      List data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('❌ Erreur lors du chargement des produits : $e');
      rethrow;
    }
  }
}
