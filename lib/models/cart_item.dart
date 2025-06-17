class CartItem {
  final int id;
  final int product;
  final String productName;
  final String productImage;
  final double productPrice;
  final int quantity;
  final String size;

  CartItem({
    required this.id,
    required this.product,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.size,

  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: json['product'],
      productName: json['product_name'],
      productImage: json['product_image'],
      productPrice: double.parse(json['product_price']),
      quantity: json['quantity'],
      size: json['size'],

    );
  }
}