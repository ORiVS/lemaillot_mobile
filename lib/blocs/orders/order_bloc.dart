import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<FetchOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await orderRepository.fetchOrders();
        emit(OrdersLoaded(orders));
      } catch (e) {
        emit(OrderError('Erreur lors du chargement des commandes.'));
      }
    });

    on<FetchOrderDetail>((event, emit) async {
      emit(OrderLoading());
      try {
        final order = await orderRepository.fetchOrderDetail(event.orderId);
        emit(OrderDetailLoaded(order));
      } catch (e) {
        emit(OrderError('Erreur lors du chargement du détail de la commande.'));
      }
    });

    on<PlaceOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        final id = await orderRepository.placeOrder(
          deliveryMethod: event.deliveryMethod,
          latitude: event.latitude,
          longitude: event.longitude,
          items: event.items,
        );
        emit(OrderPlaced(id));
      } catch (e) {
        emit(OrderError('Erreur lors du passage de la commande.'));
      }
    });

    on<PlaceOrderAndPay>((event, emit) async {
      emit(OrderLoading());

      try {
        final id = await orderRepository.placeOrder(
          deliveryMethod: event.deliveryMethod,
          latitude: event.latitude,
          longitude: event.longitude,
          items: event.items,
        );

        final checkoutUrl = await orderRepository.createStripeSession(id);

        emit(RedirectToStripe(checkoutUrl));
      } catch (e) {
        emit(OrderError('Erreur lors du paiement de la commande.'));
      }
    });
  }
}
