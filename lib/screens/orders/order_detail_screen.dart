import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/orders/order_bloc.dart';
import '../../blocs/orders/order_event.dart';
import '../../blocs/orders/order_state.dart';
import '../../models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(FetchOrderDetail(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.order;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text("Order #${order.orderNumber}", style: Theme.of(context).textTheme.titleLarge),

                  const SizedBox(height: 20),
                  Text("Status: ${order.status}"),

                  const SizedBox(height: 20),
                  Text("Items:", style: Theme.of(context).textTheme.titleMedium),
                  ...order.items.map((item) => ListTile(
                    title: Text(item.productName),
                    subtitle: Text("${item.quantity} x ${item.price.toStringAsFixed(2)} €"),
                    trailing: Text("${(item.quantity * item.price).toStringAsFixed(2)} €"),
                  )),

                  const SizedBox(height: 20),
                  Text("Shipping: ${order.deliveryMethod}"),
                  Text("Delivery cost: ${order.deliveryCost.toStringAsFixed(2)} €"),
                  Text("Total: ${order.totalPrice.toStringAsFixed(2)} €"),
                ],
              ),
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
