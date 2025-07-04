class ProductImage {
  final int id;
  final String image;
  final String? altText;
  final bool isMain;

  ProductImage({
    required this.id,
    required this.image,
    this.altText,
    this.isMain = false,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      image: json['image'],
      altText: json['alt_text'],
      isMain: json['is_main'] ?? false,
    );
  }
}
