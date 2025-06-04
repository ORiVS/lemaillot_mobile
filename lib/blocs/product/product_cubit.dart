import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/product_repository.dart';
import '../../models/product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit({required this.repository}) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final products = await repository.fetchAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }
}
