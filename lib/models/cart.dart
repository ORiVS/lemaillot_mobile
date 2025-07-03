import 'cart_item.dart';

class Cart {
  final int id;
  final int user;
  final List<CartItem> items;
  final DateTime createdAt;
  final double totalProducts;
  final double deliveryEstimate;
  final double estimatedTotal;
  final int totalItems;

  Cart({
    required this.id,
    required this.user,
    required this.items,
    required this.createdAt,
    required this.totalProducts,
    required this.deliveryEstimate,
    required this.estimatedTotal,
    required this.totalItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      user: json['user'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      totalProducts: double.parse(json['total_products'].toString()),
      totalItems: json['total_items'],
      deliveryEstimate: double.parse(json['delivery_estimate'].toString()),
      estimatedTotal: double.parse(json['estimated_total'].toString()),
    );
  }
}
