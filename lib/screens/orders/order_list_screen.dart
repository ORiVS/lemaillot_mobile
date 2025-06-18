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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => OrderBloc(OrderRepository())
                            ..add(FetchOrderDetail(order.id)),
                          child: OrderDetailScreen(orderId: order.id),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long, size: 32, color: Colors.black54),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order #${order.orderNumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${order.items.length} item${order.items.length > 1 ? 's' : ''}",
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.black54),
                      ],
                    ),
                  ),
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
