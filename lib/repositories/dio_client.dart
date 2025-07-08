import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class DioClient {
  static Dio createDio({bool withAuth = true}) {
    final dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? '',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ));

    // Ajout d'une variable locale
    final bool shouldAddAuth = withAuth;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (shouldAddAuth) {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('access_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              print('🔐 Authorization header ajouté : $token');
            } else {
              print('⚠️ Aucun token disponible pour autorisation');
            }
          } else {
            print('🟡 Appel sans authentification');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              e.response?.data['code'] == 'token_not_valid') {
            print('⛔ Token expiré → redirection /login');

            final prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
