import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/cart/cart_screen.dart';

import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repoositories.dart';

import 'blocs/cart/cart_bloc.dart';
import 'blocs/cart/cart_event.dart';
import 'repositories/cart_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print('✅ .env chargé : ${dotenv.env['API_URL']}');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
            repository: CartRepository(
              authRepository: AuthRepository(),
            ),
          )..add(LoadCart()),
        ),

      ],
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
