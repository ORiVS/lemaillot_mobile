import '../../models/product.dart';
import '../../models/wishlist_item.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> wishlistItems;

  WishlistLoaded(this.wishlistItems);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}