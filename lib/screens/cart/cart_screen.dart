import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import 'cart_filled_view.dart';
import 'empty_cart_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartTokenRefreshFailed) {
            Navigator.of(context).pushReplacementNamed('/login');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Votre session a expiré. Veuillez vous reconnecter.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
            return Center(child: Text(state.message));
          }

          if (state is CartLoaded) {
            final cart = state.cart;
            if (cart.items.isEmpty) {
              return const EmptyCartView();
            }
            return CartFilledView(cart: cart);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
