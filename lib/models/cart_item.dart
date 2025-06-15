class CartItem {
  final int id;
  final int product;
  final String productName;
  final String productImage;
  final int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.productName,
    required this.productImage,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: json['product'],
      productName: json['product_name'],
      productImage: json['product_image'],
      quantity: json['quantity'],
    );
  }
}
