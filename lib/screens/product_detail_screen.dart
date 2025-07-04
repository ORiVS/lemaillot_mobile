import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_detail/product_detail_cubit.dart';
import '../blocs/product_detail/product_detail_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    context.read<ProductDetailCubit>().loadProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is ProductDetailError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is ProductDetailLoaded) {
          final product = state.product;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [
                    // Image Carousel
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        itemCount: product.gallery.isNotEmpty ? product.gallery.length : 1,
                        itemBuilder: (context, index) {
                          final imageUrl = product.gallery.isNotEmpty
                              ? product.gallery[index]
                              : product.image;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(imageUrl, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text('${product.price.toStringAsFixed(0)} FCFA',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),

                          // Size dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedSize,
                              hint: const Text('Size'),
                              underline: const SizedBox(),
                              onChanged: (value) {
                                setState(() => selectedSize = value);
                              },
                              items: product.sizes
                                  .map((e) => DropdownMenuItem<String>(
                                value: e.size,
                                child: Text('${e.size} (${e.stock} left)'),
                              ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Quantity selector
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Quantité", style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    _circleIcon(
                                      icon: Icons.remove,
                                      onTap: quantity > 1
                                          ? () => setState(() => quantity--)
                                          : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(quantity.toString(),
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                    _circleIcon(
                                      icon: Icons.add,
                                      onTap: () => setState(() => quantity++),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Description
                          const Text('Description',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Back and Heart buttons
                Positioned(
                  top: 40,
                  left: 16,
                  child: _iconCircle(Icons.arrow_back, () {
                    Navigator.of(context).pop();
                  }),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: _iconCircle(Icons.favorite_border, () {}),
                ),
              ],
            ),

            // Bottom Add to Bag
// Remplace bottomNavigationBar par ceci :
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${product.price.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          if (selectedSize == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Veuillez sélectionner une taille'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          context.read<CartBloc>().add(AddToCart(
                            productId: product.id,
                            quantity: quantity,
                            size: selectedSize!,
                          ));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Maillot ajouté au panier'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Ajouter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _circleIcon({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _iconCircle(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}
