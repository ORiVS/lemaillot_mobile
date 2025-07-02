import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemaillot_mobile/models/notification.dart';

class NotificationRepository {
  final String baseUrl;
  final Dio dio;

  NotificationRepository({required this.baseUrl})
      : dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Méthode pour configurer le header Authorization
  Future<void> _setAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    await _setAuthHeader();
    final response = await dio.get('/api/notifications/');
    return (response.data as List)
        .map((json) => NotificationModel.fromJson(json))
        .toList();
  }

  Future<void> markAsRead(int id) async {
    await _setAuthHeader();
    await dio.post('/api/notifications/$id/mark_as_read/');
  }

  Future<int> getUnreadCount() async {
    await _setAuthHeader();
    final response = await dio.get('/api/notifications/unread_count/');
    return response.data['unread_count'];
  }
}
