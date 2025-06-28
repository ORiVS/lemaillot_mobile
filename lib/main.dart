import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lemaillot_mobile/screens/register_screen.dart';

import 'repositories/auth_repoositories.dart';
import 'repositories/cart_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/dio_client.dart';
import 'repositories/product_detail_repository.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/cart/cart_event.dart';
import 'blocs/profile/profile_cubit.dart';
import 'blocs/product_detail/product_detail_cubit.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/VerifyAccountScreen.dart';

import 'screens/profile/ProfileScreen.dart';

// 👉 Clé globale pour navigation sans contexte
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final dio = DioClient.createDio();
  final authRepository = AuthRepository();
  final productDetailRepository = ProductDetailRepository();

  print('✅ .env chargé : ${dotenv.env['API_URL']}');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(
            repository: CartRepository(authRepository: authRepository),
          )..add(LoadCart()),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileRepository(dio))..loadProfile(),
        ),
      ],
      child: ProviderScope(
        child: MyApp(productDetailRepository: productDetailRepository),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductDetailRepository productDetailRepository;

  const MyApp({super.key, required this.productDetailRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'LeMaillot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/cart': (context) => const CartScreen(),
        '/product-detail': (context) {
          final productId = ModalRoute.of(context)!.settings.arguments as int;
          return BlocProvider(
            create: (_) => ProductDetailCubit(repository: productDetailRepository)
              ..loadProduct(productId),
            child: ProductDetailScreen(productId: productId),
          );
        },
        '/verify': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return VerifyAccountScreen(email: email);
        },
      },

    );
  }
}
