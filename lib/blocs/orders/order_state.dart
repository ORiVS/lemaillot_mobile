import '../../models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  OrdersLoaded(this.orders);
}

class OrderDetailLoaded extends OrderState {
  final OrderModel order;
  OrderDetailLoaded(this.order);
}

class OrderPlaced extends OrderState {
  final int orderId;
  OrderPlaced(this.orderId);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

class RedirectToStripe extends OrderState {
  final String checkoutUrl;
  RedirectToStripe(this.checkoutUrl);
}
