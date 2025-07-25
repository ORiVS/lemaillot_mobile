  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../../blocs/cart/cart_bloc.dart';
  import '../../blocs/cart/cart_event.dart';
  import '../../blocs/orders/order_bloc.dart';
import '../../models/cart.dart';
  import 'package:flutter/material.dart';

  import '../../repositories/dio_client.dart';
import '../../repositories/order_repository.dart';
import '../checkout/checkout_screen.dart';
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
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CartHeader(),
              const SizedBox(height: 16),
              ...cart.items.map((item) => CartItemTile(item: item)),
              const SizedBox(height: 24),
              CartSummary(cart: cart),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => OrderBloc(
                          orderRepository: OrderRepository(dio: DioClient.createDio()),
                        ),
                        child: CheckoutScreen(cart: cart),
                      ),
                    ),
                  );
                },

                child: const Text("Commander", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),

        ),
      );
    }
  }
