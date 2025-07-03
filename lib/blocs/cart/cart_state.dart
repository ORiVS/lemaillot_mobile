import '../../models/cart.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;
  CartLoaded(this.cart);

  int get totalItems {
    return cart.items.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartTokenRefreshFailed extends CartState {
  final String message;
  CartTokenRefreshFailed(this.message);
}
