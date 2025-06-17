import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../models/cart.dart';
import 'package:flutter/material.dart';

import 'cart_coupon_field.dart';
import 'cart_item_tile.dart';
import 'cart_summary.dart';
import 'cart_header.dart';


class CartFilledView extends StatelessWidget {
  final Cart cart;

  const CartFilledView({required this.cart});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CartHeader(),
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
