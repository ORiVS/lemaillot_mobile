import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../blocs/product/product_cubit.dart';
import '../blocs/product/product_state.dart';
import '../blocs/profile/profile_cubit.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../blocs/product_detail/product_detail_cubit.dart';
import '../repositories/product_detail_repository.dart';
import '../repositories/profile_repository.dart';
import '../screens/product_detail_screen.dart';
import '../screens/orders/order_list_screen.dart';
import '../repositories/order_repository.dart';
import '../blocs/orders/order_bloc.dart';
import '../theme/app_icons.dart';
import 'profile/ProfileScreen.dart';
import '../repositories/dio_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductCubit _productCubit;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _productCubit = ProductCubit(repository: ProductRepository());
    _productCubit.fetchProducts();
  }

  @override
  void dispose() {
    _productCubit.close();
    super.dispose();
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildProductView();
      case 2:
        return BlocProvider(
          create: (_) => OrderBloc(OrderRepository()),
          child: OrderListScreen(),
        );
      default:
        return const Center(child: Text('Screen in progress...'));
    }
  }

  Widget _buildProductView() {
    return Padding(
      padding: const EdgeInsets.all(16),
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
                        create: (_) => ProfileCubit(ProfileRepository(DioClient.createDio()))..loadProfile(),
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


              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: const Icon(AppIcons.cart, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(AppIcons.search),
                hintText: 'Search',
                border: InputBorder.none,
              ),
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
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  return GridView.builder(
                    itemCount: state.products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: state.products[index]);
                    },
                  );
                } else if (state is ProductError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Icon(AppIcons.home,
                      color: _selectedIndex == 0 ? Colors.black : Colors.grey),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Icon(AppIcons.notifications,
                      color: _selectedIndex == 1 ? Colors.black : Colors.grey),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 2),
                  child: Icon(AppIcons.orders,
                      color: _selectedIndex == 2 ? Colors.black : Colors.grey),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 3),
                  child: Icon(AppIcons.profile,
                      color: _selectedIndex == 3 ? Colors.black : Colors.grey),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ProductDetailCubit(repository: ProductDetailRepository()),
              child: ProductDetailScreen(productId: product.id),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(AppIcons.favorite),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${product.price.toStringAsFixed(0)} FCFA',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (product.discountPrice != null) const SizedBox(width: 6),
                if (product.discountPrice != null)
                  Text(
                    '${product.discountPrice!.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
