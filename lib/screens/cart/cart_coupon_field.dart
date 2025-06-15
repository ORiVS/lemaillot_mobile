import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../models/cart.dart';
import 'package:flutter/material.dart';

class CouponField extends StatelessWidget {
  const CouponField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.discount, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Coupon Code',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}
