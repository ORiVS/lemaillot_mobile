import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../models/cart.dart';
import 'package:flutter/material.dart';

import '../../models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(item.productImage, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("Size: M  Color: -", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text("${item.quantity * 10000} FCFA"), // 🔁 À remplacer par le vrai prix unitaire
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.black),
                  onPressed: () {
                    context.read<CartBloc>().add(UpdateCartItem(
                      productId: item.product,
                      quantity: item.quantity + 1,
                    ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.black),
                  onPressed: () {
                    context.read<CartBloc>().add(UpdateCartItem(
                      productId: item.product,
                      quantity: item.quantity - 1,
                    ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
