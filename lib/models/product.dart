import 'package:lemaillot_mobile/models/product_image.dart';

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final double? discountPrice;
  final bool isNew;
  final bool isFeatured;
  final List<ProductImage> gallery;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.discountPrice,
    this.isNew = false,
    this.isFeatured = false,
    required this.gallery
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['product_name'],
      imageUrl: json['image'],
      price: double.parse(json['price'].toString()),
      discountPrice:
          json['discount_price'] != null
              ? double.parse(json['discount_price'].toString())
              : null,
      isNew: json['is_new'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      gallery: (json['gallery'] as List)
          .map((img) => ProductImage.fromJson(img))
          .toList(),

    );
  }
}
