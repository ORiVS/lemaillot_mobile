import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_detail_state.dart';
import '../../repositories/product_detail_repository.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailRepository repository;

  ProductDetailCubit({required this.repository}) : super(ProductDetailInitial());

  Future<void> loadProduct(int id) async {
    emit(ProductDetailLoading());
    try {
      final product = await repository.fetchProductDetail(id);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError('Failed to load product'));
    }
  }
}
