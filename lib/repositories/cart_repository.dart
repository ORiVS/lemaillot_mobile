import 'package:dio/dio.dart';
import '../models/cart.dart';
import '../repositories/auth_repoositories.dart';
import 'dio_client.dart';

class CartRepository {
  final Dio _dio = DioClient.createDio();
  final AuthRepository authRepository;
  CartRepository({required this.authRepository});



  Future<Cart> fetchCart() async {
    print('🛒 Chargement du panier en cours...');
    final response = await _dio.get('/cart/');
    return Cart.fromJson(response.data);
  }

  Future<void> addProductToCart(int productId, int quantity, String size) async {
    await _dio.post('/cart/add/', data: {
      'product': productId,
      'quantity': quantity,
      'size': size,
    });
  }

  Future<void> updateCartItem(int productId, int quantity, String size) async {
    await _dio.put('/cart/update/', data: {
      'product': productId,
      'quantity': quantity,
      'size': size,
    });
  }

  Future<void> removeFromCart(int productId, String size) async {
    await _dio.delete('/cart/remove/', data: {
      'product': productId,
      'size': size,
    });
  }

  Future<void> clearCart() async {
    await _dio.delete('/cart/clear/');
  }
}
