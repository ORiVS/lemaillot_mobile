import 'package:lemaillot_mobile/models/product.dart';

class WishlistItem {
  final int id;
  final Product product;
  final DateTime addedAt;

  WishlistItem({required this.id, required this.product, required this.addedAt});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      addedAt: DateTime.parse(json['added_at']),
    );
  }
}
