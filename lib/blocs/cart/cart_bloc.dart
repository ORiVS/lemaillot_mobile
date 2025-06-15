import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../repositories/cart_repository.dart';
import '../../repositories/auth_repoositories.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await repository.fetchCart();
      emit(CartLoaded(cart));
    } catch (e) {
      if (e is TokenRefreshFailedException) {
        emit(CartTokenRefreshFailed('Session expirée. Veuillez vous reconnecter.'));
      } else {
        emit(CartError('Erreur lors du chargement du panier'));
      }
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await repository.addProductToCart(event.productId, event.quantity);
      add(LoadCart());
    } catch (e) {
      if (e is TokenRefreshFailedException) {
        emit(CartTokenRefreshFailed('Session expirée. Veuillez vous reconnecter.'));
      } else {
        emit(CartError('Erreur lors de l’ajout au panier'));
      }
    }
  }

  Future<void> _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) async {
    try {
      await repository.updateCartItem(event.productId, event.quantity);
      add(LoadCart());
    } catch (e) {
      if (e is TokenRefreshFailedException) {
        emit(CartTokenRefreshFailed('Session expirée. Veuillez vous reconnecter.'));
      } else {
        emit(CartError('Erreur lors de la mise à jour de l’article'));
      }
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      await repository.removeFromCart(event.productId);
      add(LoadCart());
    } catch (e) {
      if (e is TokenRefreshFailedException) {
        emit(CartTokenRefreshFailed('Session expirée. Veuillez vous reconnecter.'));
      } else {
        emit(CartError('Erreur lors de la suppression de l’article'));
      }
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await repository.clearCart();
      add(LoadCart());
    } catch (e) {
      if (e is TokenRefreshFailedException) {
        emit(CartTokenRefreshFailed('Session expirée. Veuillez vous reconnecter.'));
      } else {
        emit(CartError('Erreur lors du vidage du panier'));
      }
    }
  }
}
