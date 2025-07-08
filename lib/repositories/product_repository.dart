import 'package:dio/dio.dart';
import '../models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

  Future<List<Product>> fetchAllProducts({String? categorySlug}) async {
    print('🔗 API_URL utilisée : ${dotenv.env['API_URL']}');

    try {
      final queryParams = <String, dynamic>{};
      if (categorySlug != null && categorySlug != 'Tous') {
        queryParams['category'] = categorySlug;
      }

      final response = await _dio.get(
        '/api/store/products/',
        queryParameters: queryParams,
      );

      print('📦 Requête produits envoyée, status : ${response.statusCode}');
      print('📦 Données reçues : ${response.data}');

      if (response.statusCode == 200 && response.data is List) {
        List data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          "⚠️ La réponse n'est pas une liste JSON. Reçu : ${response.data}",
        );
      }
    } catch (e) {
      print('❌ Erreur lors du chargement des produits : $e');
      rethrow;
    }
  }

}
