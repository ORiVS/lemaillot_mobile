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

    print('🕐 Dio Timeout config → '
        'connectTimeout=${dio.options.connectTimeout}, '
        'receiveTimeout=${dio.options.receiveTimeout}, '
        'sendTimeout=${dio.options.sendTimeout}');

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (withAuth) {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('access_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              print('🔐 Token ajouté au header : $token');
              print('🔐 Authorization header : ${options.headers['Authorization']}');
            } else {
              print('⚠️ Aucun token trouvé');
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              e.response?.data['code'] == 'token_not_valid') {
            print('🔐 Token expiré → redirection vers /login');

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
