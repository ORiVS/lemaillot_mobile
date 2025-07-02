import 'package:dio/dio.dart';
import '../models/wishlist_item.dart';
import 'dio_client.dart';

class WishlistRepository {
  final Dio _dio = DioClient.createDio();

  Future<List<WishlistItem>> fetchWishlist() async {
    final response = await _dio.get('/api/wishlist/');
    return (response.data as List)
        .map((item) => WishlistItem.fromJson(item))
        .toList();
  }

  Future<void> addToWishlist(int productId) async {
    await _dio.post('/api/wishlist/', data: {'product_id': productId});
  }

  Future<void> removeFromWishlist(int id) async {
    await _dio.delete('/api/wishlist/$id/remove/');
  }
}
