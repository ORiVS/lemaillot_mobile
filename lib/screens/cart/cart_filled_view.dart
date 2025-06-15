import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../models/cart.dart';
import 'package:flutter/material.dart';

import 'cart_coupon_field.dart';
import 'cart_item_tile.dart';
import 'cart_summary.dart';

class CartFilledView extends StatelessWidget {
  final Cart cart;

  const CartFilledView({required this.cart});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
              const Text("Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => context.read<CartBloc>().add(ClearCart()),
                child: const Text("Remove All"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...cart.items.map((item) => CartItemTile(item: item)),
          const SizedBox(height: 24),
          CartSummary(cart: cart),
          const SizedBox(height: 16),
          CouponField(),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {},
            child: const Text("Checkout", style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }
}
