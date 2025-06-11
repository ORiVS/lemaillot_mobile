import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product_detail.dart';

class ProductDetailRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));

  Future<ProductDetail> fetchProductDetail(int id) async {
    try {
      final response = await _dio.get('/api/store/products/$id/');
      print('📥 ProductDetail loaded for ID $id');
      print('✅ Data: ${response.data}');
      return ProductDetail.fromJson(response.data);
    } catch (e) {
      print('❌ Error loading product detail: $e');
      rethrow;
    }
  }
}
