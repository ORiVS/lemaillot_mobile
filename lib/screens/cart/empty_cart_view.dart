import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_bag, size: 100, color: Colors.amber),
          SizedBox(height: 20),
          Text("Your Cart is Empty", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
