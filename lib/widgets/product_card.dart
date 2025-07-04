import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_detail/product_detail_cubit.dart';
import '../blocs/wishlist/wishlist_cubit.dart';
import '../blocs/wishlist/wishlist_state.dart';
import '../models/product.dart';
import '../models/product_image.dart';
import '../repositories/product_detail_repository.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        bool isWishlisted = false;

        if (state is WishlistLoaded) {
          isWishlisted = state.wishlistItems.any((item) => item.product.id == product.id);
        }

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
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          final cubit = context.read<WishlistCubit>();
                          if (isWishlisted) {
                            cubit.remove(product.id); // ici product.id est un int
                          } else {
                            cubit.add(product.id);
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey(isWishlisted),
                            color: isWishlisted ? Colors.red : Colors.black,
                          ),
                        ),
                      ),
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
      },
    );
  }
}
