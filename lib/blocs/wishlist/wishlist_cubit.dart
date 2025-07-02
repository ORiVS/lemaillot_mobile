import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/wishlist_repository.dart';
import '../../models/wishlist_item.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository repository;

  WishlistCubit(this.repository) : super(WishlistInitial());

  void fetchWishlist() async {
    emit(WishlistLoading());
    try {
      final items = await repository.fetchWishlist(); // List<WishlistItem>
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError('Erreur lors du chargement des favoris'));
    }
  }

  void add(int productId) async {
    try {
      await repository.addToWishlist(productId);
      fetchWishlist(); // Recharger la liste après ajout
    } catch (_) {
      emit(WishlistError("Impossible d'ajouter aux favoris"));
    }
  }

  void remove(int id) async {
    try {
      await repository.removeFromWishlist(id); // id du WishlistItem
      fetchWishlist(); // Recharger la liste après suppression
    } catch (_) {
      emit(WishlistError("Erreur lors de la suppression"));
    }
  }
}
