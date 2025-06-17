abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final int productId;
  final int quantity;
  final String size;

  AddToCart({required this.productId, required this.quantity, required this.size,});
}

class UpdateCartItem extends CartEvent {
  final int productId;
  final int quantity;
  final String size;


  UpdateCartItem({required this.productId, required this.quantity, required this.size});
}

class RemoveFromCart extends CartEvent {
  final int productId;
  final String size;

  RemoveFromCart({required this.productId, required this.size});
}

class ClearCart extends CartEvent {}
