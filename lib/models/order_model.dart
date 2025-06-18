class OrderItemModel {
  final int product;
  final String productName;
  final String vendorName;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.product,
    required this.productName,
    required this.vendorName,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: json['product'],
      productName: json['product_name'],
      vendorName: json['vendor_name'],
      quantity: json['quantity'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}

class OrderModel {
  final int id;
  final String orderNumber;
  final String customerEmail;
  final String status;
  final double totalPrice;
  final double deliveryCost;
  final String deliveryMethod;
  final String createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerEmail,
    required this.status,
    required this.totalPrice,
    required this.deliveryCost,
    required this.deliveryMethod,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number'],
      customerEmail: json['customer_email'],
      status: json['status'],
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      deliveryCost: double.tryParse(json['delivery_cost'].toString()) ?? 0.0,
      deliveryMethod: json['delivery_method'],
      createdAt: json['created_at'],
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
    );
  }
}
