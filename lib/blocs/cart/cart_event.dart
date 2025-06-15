abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final int productId;
  final int quantity;

  AddToCart({required this.productId, required this.quantity});
}

class UpdateCartItem extends CartEvent {
  final int productId;
  final int quantity;

  UpdateCartItem({required this.productId, required this.quantity});
}

class RemoveFromCart extends CartEvent {
  final int productId;

  RemoveFromCart({required this.productId});
}

class ClearCart extends CartEvent {}
