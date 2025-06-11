import '../../models/product_detail.dart';

abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductDetail product;

  ProductDetailLoaded(this.product);
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError(this.message);
}
