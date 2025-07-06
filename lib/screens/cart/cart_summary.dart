import '../../models/cart.dart';
import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final Cart cart;

  const CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow("Sous-total", cart.totalProducts),
        _buildRow("Frais de livraison", cart.deliveryEstimate),
        _buildRow("Tax", 0.0),
        const Divider(thickness: 1),
        _buildRow("Total", cart.estimatedTotal, bold: true),
      ],
    );
  }

  Widget _buildRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(
            "${value.toStringAsFixed(0)} FCFA",
            style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
