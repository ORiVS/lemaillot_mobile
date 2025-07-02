import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/wishlist/wishlist_cubit.dart';
import '../../blocs/wishlist/wishlist_state.dart';
import '../../models/product.dart';
import '../../models/wishlist_item.dart';
import '../../theme/app_icons.dart';
import '../../screens/product_detail_screen.dart';
import '../../blocs/product_detail/product_detail_cubit.dart';
import '../../repositories/product_detail_repository.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistLoaded) {
            final items = state.wishlistItems;

            if (items.isEmpty) {
              return const Center(child: Text("Aucun favori pour l'instant."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index].product;
                final wishlistItemId = items[index].id;
                return WishlistCard(
                  product: product,
                  wishlistItemId: wishlistItemId,
                );
              },
            );
          } else {
            return const Center(child: Text('Erreur lors du chargement.'));
          }
        },
      ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final Product product;
  final int wishlistItemId;

  const WishlistCard({super.key, required this.product, required this.wishlistItemId});

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
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  context.read<WishlistCubit>().remove(wishlistItemId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
