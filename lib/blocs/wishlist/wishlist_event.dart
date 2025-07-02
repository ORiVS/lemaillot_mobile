abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final int productId;
  AddToWishlist(this.productId);
}

class RemoveFromWishlist extends WishlistEvent {
  final int itemId;
  RemoveFromWishlist(this.itemId);
}
