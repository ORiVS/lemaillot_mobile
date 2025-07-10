import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dio/dio.dart';
import 'package:lemaillot_mobile/repositories/order_repository.dart';
import 'package:lemaillot_mobile/screens/checkout/checkout_screen.dart';
import 'package:lemaillot_mobile/screens/orders/order_confirmation_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blocs/orders/order_bloc.dart';
import 'blocs/orders/order_state.dart';
import 'models/cart.dart';
import 'repositories/notification_repository.dart';
import 'repositories/auth_repoositories.dart';
import 'repositories/cart_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/dio_client.dart';
import 'repositories/product_detail_repository.dart';
import 'repositories/wishlist_repository.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/cart/cart_event.dart';
import 'blocs/profile/profile_cubit.dart';
import 'blocs/product_detail/product_detail_cubit.dart';
import 'blocs/wishlist/wishlist_cubit.dart';
import 'blocs/notifications/notification_cubit.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/register_screen.dart';
import 'screens/VerifyAccountScreen.dart';
import 'screens/profile/ProfileScreen.dart';

import 'package:app_links/app_links.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late final AppLinks _appLinks;
final dio = DioClient.createDio();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('fr_FR', null);

  final dio = DioClient.createDio();
  final authRepository = AuthRepository();
  final productDetailRepository = ProductDetailRepository();
  final wishlistRepository = WishlistRepository();
  final notificationRepository = NotificationRepository(baseUrl: dotenv.env['API_URL']!);

  print('✅ .env chargé : ${dotenv.env['API_URL']}');
  await _setupDeepLinkListener();

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
        BlocProvider<WishlistCubit>(
          create: (_) => WishlistCubit(wishlistRepository)..fetchWishlist(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => NotificationCubit(notificationRepository),
        ),
      ],
      child: ProviderScope(
        child: MyApp(productDetailRepository: productDetailRepository),
      ),
    ),
  );
}

Future<void> _setupDeepLinkListener() async {
  _appLinks = AppLinks();

  _appLinks.uriLinkStream.listen((uri) {
    if (uri == null) return;

    if (uri.toString().startsWith('myapp://checkout-success')) {
      navigatorKey.currentState?.pushNamed('/order-confirmation');
    } else if (uri.toString().startsWith('myapp://checkout-cancel')) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text("Paiement annulé.")),
      );
    }
  });
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
        '/order-confirmation': (context) => const OrderConfirmationScreen(),
        '/checkout': (context) {
          final cart = ModalRoute.of(context)!.settings.arguments as Cart;

          return BlocProvider<OrderBloc>(
            create: (_) => OrderBloc(orderRepository: OrderRepository(dio: DioClient.createDio()),),
            child: Builder(
              builder: (context) => BlocListener<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is RedirectToStripe) {
                    launchUrl(Uri.parse(state.checkoutUrl), mode: LaunchMode.externalApplication);
                  } else if (state is OrderError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: CheckoutScreen(cart: cart),
              ),
            ),
          );
        },


        '/home': (context) => const HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/cart': (context) => const CartScreen(),
        '/product-detail': (context) {
          final productId = ModalRoute.of(context)!.settings.arguments as int;
          return BlocProvider(
            create: (_) => ProductDetailCubit(repository: productDetailRepository)..loadProduct(productId),
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
