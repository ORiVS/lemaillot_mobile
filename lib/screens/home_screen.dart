import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/notifications/notification_cubit.dart';
import '../blocs/notifications/notification_state.dart';
import '../blocs/product/product_cubit.dart';
import '../blocs/product/product_state.dart';
import '../blocs/profile/profile_cubit.dart';
import '../blocs/wishlist/wishlist_cubit.dart';
import '../blocs/wishlist/wishlist_state.dart';
import '../models/product.dart';
import '../repositories/notification_repository.dart';
import '../repositories/product_repository.dart';
import '../blocs/product_detail/product_detail_cubit.dart';
import '../repositories/product_detail_repository.dart';
import '../repositories/profile_repository.dart';
import '../screens/product_detail_screen.dart';
import '../screens/orders/order_list_screen.dart';
import '../repositories/order_repository.dart';
import '../blocs/orders/order_bloc.dart';
import '../theme/app_icons.dart';
import '../utils/auth_guard.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'notifications_screen.dart';
import 'profile/ProfileScreen.dart';
import '../repositories/dio_client.dart';
import '../widgets/product_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductCubit _productCubit;
  int _selectedIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _sortOption = 'default';



  Future<void> _handleRefresh() async {
    _productCubit.fetchProducts(); // Async en interne, pas besoin de await ici
    context.read<NotificationCubit>().fetchNotifications(); // idem
    context.read<CartBloc>().add(LoadCart()); // Ne pas await un add()
    await Future.delayed(const Duration(milliseconds: 500)); // Optionnel : pour animation
  }




  @override
  void initState() {
    super.initState();
    _productCubit = ProductCubit(repository: ProductRepository());
    _productCubit.fetchProducts();
  }

  @override
  void dispose() {
    _productCubit.close();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildProductView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header : avatar + panier
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                            ProfileCubit(ProfileRepository(DioClient.createDio()))
                              ..loadProfile(),
                            child: const ProfileScreen(),
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      int itemCount = 0;

                      if (state is CartLoaded) {
                        itemCount = state.cart.items.fold(0, (sum, item) => sum + item.quantity);
                      }

                      return GestureDetector(
                        onTap: () async {
                          final allowed = await checkAuthOrPrompt(context);
                          if (allowed) {
                            Navigator.pushNamed(context, '/cart');
                          }
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: const Icon(AppIcons.cart, color: Colors.white),
                            ),
                            if (itemCount > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                  child: Text(
                                    '$itemCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                ],
              ),
              const SizedBox(height: 20),

// 🔍 Barre de recherche + Bouton de tri
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    // 🔍 Barre de recherche avec Clear
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(AppIcons.search, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase().trim();
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Rechercher un maillot',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: const Icon(Icons.close, size: 20, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 🔽🔼 Bouton tri
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() => _sortOption = value);
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      icon: SizedBox(
                        width: 32,
                        height: 32,
                        child: Stack(
                          alignment: Alignment.center,
                          children: const [
                            Positioned(
                              top: 3,
                              child: Icon(LucideIcons.chevronUp, size: 16),
                            ),
                            Positioned(
                              bottom: 3,
                              child: Icon(LucideIcons.chevronDown, size: 16),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'default', child: Text('Pertinence')),
                        PopupMenuItem(value: 'price_low', child: Text('Prix croissant')),
                        PopupMenuItem(value: 'price_high', child: Text('Prix décroissant')),
                        PopupMenuItem(value: 'new', child: Text('Nouveautés')),
                      ],
                    ),
                  ],
                ),
              ),



              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tous les maillots',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),

          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is ProductLoaded) {
                final filteredProducts = state.products.where((product) {
                  return product.name.toLowerCase().contains(_searchQuery);
                }).toList();
                if (_sortOption == 'price_low') {
                  filteredProducts.sort((a, b) => a.price.compareTo(b.price));
                } else if (_sortOption == 'price_high') {
                  filteredProducts.sort((a, b) => b.price.compareTo(a.price));
                } else if (_sortOption == 'new') {
                  filteredProducts.sort((b, a) => a.isNew ? 1 : -1);
                }
                if (filteredProducts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Center(child: Text('Aucun maillot trouvé.')),
                  );
                }

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // ⚠️ on empêche le scroll interne
                  shrinkWrap: true, // ✅ important
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                );
              } else if (state is ProductError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(child: Text(state.message)),
                );
              }
              return const SizedBox();
            },
          ),

            ],
          ),
        ),
      )
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildProductView();
      case 1:
        return const NotificationsScreen();
      case 2:
        return BlocProvider(
          create: (_) => OrderBloc(OrderRepository()),
          child: OrderListScreen(),
        );
      case 3:
        return BlocProvider(
          create: (_) => ProfileCubit(ProfileRepository(DioClient.createDio()))
            ..loadProfile(),
          child: const ProfileScreen(),
        );
      default:
        return const Center(child: Text('Screen in progress...'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productCubit),
        BlocProvider(
          create: (_) => NotificationCubit(NotificationRepository(baseUrl: dotenv.env['API_URL']!))
            ..fetchNotifications(), // Charger dès le début
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        bottomNavigationBar: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, notifState) {
            bool hasUnread = false;
            if (notifState is NotificationLoaded) {
              hasUnread = notifState.hasUnread;
            }
            return CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) => setState(() => _selectedIndex = index),
              hasUnreadNotifications: hasUnread,
            );
          },
        ),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

}
