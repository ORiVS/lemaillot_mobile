import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import 'dio_client.dart';

class OrderRepository {
  final Dio _dio = DioClient.createDio();

  OrderRepository();

  Future<List<OrderModel>> fetchOrders() async {
    try {
      debugPrint('📦 Récupération des commandes...');
      final response = await _dio.get('/orders/');
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
      final response = await _dio.get('/orders/$id/');
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ Exception in fetchOrderDetail: ${e.message}');
      throw Exception("Erreur lors du chargement du détail de la commande");
    }
  }

  Future<int> placeOrder({
    required String deliveryMethod,
    double? latitude,
    double? longitude,
    required List<Map<String, dynamic>> items,
  }) async {
    final data = {
      "delivery_method": deliveryMethod,
      "delivery_latitude": latitude,
      "delivery_longitude": longitude,
      "items": items,
    };

    try {
      debugPrint('📤 Passage de la commande...');
      final response = await _dio.post('/orders/create/', data: data);
      return response.data['id'];
    } on DioException catch (e) {
      debugPrint('❌ Exception in placeOrder: ${e.message}');
      throw Exception("Erreur lors du passage de la commande");
    }
  }
}
