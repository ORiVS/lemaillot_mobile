import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderRepository {
  final Dio dio;

  OrderRepository({required this.dio});

  Future<List<OrderModel>> fetchOrders() async {
    try {
      debugPrint('📦 Récupération des commandes...');
      final response = await dio.get('/orders/');
      return (response.data as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ Exception in fetchOrders: ${e.message}');
      throw Exception("Erreur lors du chargement des commandes");
    }
  }

  Future<OrderModel> fetchOrderDetail(int id) async {
    try {
      debugPrint('📦 Récupération du détail commande $id...');
      final response = await dio.get('/orders/$id/');
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ Exception in fetchOrderDetail: ${e.message}');
      throw Exception("Erreur lors du chargement du détail de la commande");
    }
  }

  Future<String> createStripeSession(int orderId) async {
    final response = await dio.post(
      '/api/payments/create-checkout-session/',
      data: {"order_id": orderId},
    );
    return response.data['checkout_url'];
  }

  Future<int> placeOrder({
    required String deliveryMethod,
    double? latitude,
    double? longitude,
    required List<Map<String, dynamic>> items,
  }) async {
    final data = {
      "delivery_method": deliveryMethod,
      "items": items,
    };

    try {
      debugPrint('📤 Passage de la commande...');
      debugPrint('📤 Données envoyées : $data');
      final response = await dio.post('/orders/create/', data: data);
      return response.data['id'];
    } on DioException catch (e) {
      debugPrint('❌ Exception in placeOrder: ${e.message}');
      throw Exception("Erreur lors du passage de la commande");
    }
  }
}
