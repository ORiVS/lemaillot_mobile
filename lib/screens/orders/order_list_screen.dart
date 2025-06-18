import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../blocs/orders/order_bloc.dart';
import '../../blocs/orders/order_event.dart';
import '../../blocs/orders/order_state.dart';
import '../../repositories/order_repository.dart';
import 'order_detail_screen.dart';

class OrderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(FetchOrders());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 80),
                    SizedBox(height: 16),
                    Text('No Orders yet'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return ListTile(
                  title: Text("Order #${order.orderNumber}"),
                  subtitle: Text("${order.items.length} items"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => OrderBloc(OrderRepository(Dio()))
                            ..add(FetchOrderDetail(order.id)),
                          child: OrderDetailScreen(orderId: order.id),
                        ),
                      ),
                    );
                  },
                );
              },
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
