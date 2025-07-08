import 'package:dio/dio.dart';
import '../models/category.dart';
import '../repositories/dio_client.dart';

class CategoryRepository {
  final Dio _dio = DioClient.createDio();

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get('/store/categories/');
      return (response.data as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des catégories');
    }
  }
}