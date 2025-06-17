import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/product_detail/product_detail_cubit.dart';
import '../blocs/product_detail/product_detail_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';

import '../models/product_detail.dart';

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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProductDetailError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is ProductDetailLoaded) {
          final product = state.product;

          return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.price.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {
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
                          content: Text('Produit ajouté au panier'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('Add to Bag'),
                  ),
                ],
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Galerie d'images (première image pour l'instant)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Nom + Prix
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${product.price.toStringAsFixed(0)} FCFA',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Dropdown de tailles
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Select Size'),
                    value: selectedSize,
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

                // Sélecteur de quantité
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Text("Quantity", style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(product.description),
              ],
            ),
          );
        }

        return const SizedBox.shrink(); // Cas non prévu
      },
    );
  }
}
