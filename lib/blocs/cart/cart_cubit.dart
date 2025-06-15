import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lemaillot_mobile/models/cart.dart';
import 'package:lemaillot_mobile/providers/cart_provider.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartProvider cartProvider;

  CartCubit({required this.cartProvider}) : super(CartInitial());

  /// 🔄 Recharger le panier
  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final cart = await cartProvider.fetchCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// ➕ Ajouter un article
  Future<void> addToCart(int productId, int quantity) async {
    try {
      await cartProvider.addToCart(productId, quantity);
      await loadCart(); // Rechargement
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// 🔁 Modifier quantité
  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      await cartProvider.updateQuantity(productId, quantity);
      await loadCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// ❌ Supprimer un produit
  Future<void> removeFromCart(int productId) async {
    try {
      await cartProvider.removeFromCart(productId);
      await loadCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// 🧹 Vider le panier
  Future<void> clearCart() async {
    try {
      await cartProvider.clearCart();
      await loadCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
