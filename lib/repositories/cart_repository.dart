import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';
import '../repositories/auth_repoositories.dart';

class CartRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? ''));
  final AuthRepository authRepository;

  CartRepository({required this.authRepository});

  Future<Map<String, String>> _authHeader() async {
    final token = await authRepository.getSavedToken();
    print('🔐 Header utilisé avec token : $token');
    if (token == null) throw Exception('Token non trouvé');
    return {'Authorization': 'Bearer $token'};
  }

  Future<Response> _handleRequest(
      Future<Response> Function(Map<String, String> headers) requestBuilder,
      ) async {
    try {
      final headers = await _authHeader();
      print('📤 Envoi requête avec headers : $headers');
      return await requestBuilder(headers);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('🔄 Token expiré. Tentative de rafraîchissement...');
        final newAccessToken = await authRepository.refreshAccessToken();
        if (newAccessToken != null) {
          print('✅ Nouveau token : $newAccessToken');
          final newHeaders = await _authHeader();
          return await requestBuilder(newHeaders);
        } else {
          print('❌ Rafraîchissement échoué');
          throw Exception('Échec du rafraîchissement du token');
        }
      } else {
        print('❌ Erreur HTTP ${e.response?.statusCode}');
        print('❌ Message : ${e.message}');
        print('❌ Body : ${e.response?.data}');
        rethrow;
      }
    }
  }

  Future<Cart> fetchCart() async {
    print('🛒 Chargement du panier en cours...');
    return await _handleRequest((headers) async {
      final response = await _dio.get('/cart/', options: Options(headers: headers));
      return Response<Cart>(
        data: Cart.fromJson(response.data),
        requestOptions: response.requestOptions,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    }).then((res) => res.data!);
  }

  Future<void> addProductToCart(int productId, int quantity, String size) async {
    await _handleRequest((headers) async {
      return await _dio.post(
        '/cart/add/',
        data: {
          'product': productId,
          'quantity': quantity,
          'size': size,
        },
        options: Options(headers: headers),
      );
    });
  }

  Future<void> updateCartItem(int productId, int quantity, String size) async {
    await _handleRequest((headers) async {
      return await _dio.put(
        '/cart/update/',
        data: {
          'product': productId,
          'quantity': quantity,
          'size': size,
        },
        options: Options(headers: headers),
      );
    });
  }

  Future<void> removeFromCart(int productId, String size) async {
    await _handleRequest((headers) async {
      return await _dio.delete(
        '/cart/remove/',
        data: {
          'product': productId,
          'size': size,
        },
        options: Options(headers: headers),
      );
    });
  }

  Future<void> clearCart() async {
    await _handleRequest((headers) async {
      return await _dio.delete(
        '/cart/clear/',
        options: Options(headers: headers),
      );
    });
  }
}


class TokenRefreshFailedException implements Exception {
  final String message;
  TokenRefreshFailedException([this.message = 'Échec du rafraîchissement du token']);

  @override
  String toString() => message;
}
