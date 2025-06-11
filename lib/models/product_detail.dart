class ProductDetail {
  final int id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String image;
  final List<String> gallery;
  final List<ProductSize> sizes;

  ProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.image,
    required this.gallery,
    required this.sizes,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      name: json['product_name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      discountPrice:
          json['discount_price'] != null
              ? double.tryParse(json['discount_price'].toString())
              : null,
      image: json['image'],
      gallery: (json['gallery'] as List).map((e) => e.toString()).toList(),
      sizes:
          (json['sizes_display'] as List)
              .map((e) => ProductSize.fromJson(e))
              .toList(),
    );
  }
}

class ProductSize {
  final String size;
  final int stock;

  ProductSize({required this.size, required this.stock});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(size: json['size'], stock: json['stock']);
  }
}
