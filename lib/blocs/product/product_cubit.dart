import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../repositories/product_repository.dart';
import '../../models/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(ProductLoading());

  Future<void> fetchProducts() async {
    try {
      emit(ProductLoading());
      final products = await repository.fetchAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Échec du chargement'));
    }
  }
}
