import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';

class OrderRepository {
  final Dio dio;

  OrderRepository(this.dio) {
    dio.options.baseUrl = dotenv.env['API_URL'] ?? 'http://192.168.1.71:8000';
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        debugPrint('🔵 [REQUEST] ${options.method} ${options.uri}');
        debugPrint('📦 Headers: ${options.headers}');
        debugPrint('📤 Body: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('🟢 [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
        debugPrint('📥 Data: ${response.data}');
        handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint('🔴 [ERROR] ${e.requestOptions.method} ${e.requestOptions.uri}');
        debugPrint('⛔ Status: ${e.response?.statusCode}');
        debugPrint('❌ Message: ${e.message}');
        debugPrint('📃 Response Data: ${e.response?.data}');
        handler.next(e);
      },
    ));
  }

  Future<List<OrderModel>> fetchOrders() async {
    try {
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
      final response = await dio.get('/orders/$id/');
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
      final response = await dio.post('/orders/create/', data: data);
      return response.data['id'];
    } on DioException catch (e) {
      debugPrint('❌ Exception in placeOrder: ${e.message}');
      throw Exception("Erreur lors du passage de la commande");
    }
  }
}
