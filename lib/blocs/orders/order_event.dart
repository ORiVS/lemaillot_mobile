abstract class OrderEvent {}

class FetchOrders extends OrderEvent {}

class FetchOrderDetail extends OrderEvent {
  final int orderId;
  FetchOrderDetail(this.orderId);
}

class PlaceOrder extends OrderEvent {
  final String deliveryMethod;
  final double? latitude;
  final double? longitude;
  final List<Map<String, dynamic>> items;

  PlaceOrder({
    required this.deliveryMethod,
    this.latitude,
    this.longitude,
    required this.items,
  });
}

class PlaceOrderAndPay extends OrderEvent {
  final String deliveryMethod;
  final double? latitude;
  final double? longitude;
  final List<Map<String, dynamic>> items;

  PlaceOrderAndPay({
    required this.deliveryMethod,
    this.latitude,
    this.longitude,
    required this.items,
  });
}

