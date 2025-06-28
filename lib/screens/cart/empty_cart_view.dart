import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'cart_header.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const CartHeader(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(LucideIcons.shoppingBag, size: 100, color: Colors.amber),
                  SizedBox(height: 20),
                  Text("Votre panier est vide", style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
