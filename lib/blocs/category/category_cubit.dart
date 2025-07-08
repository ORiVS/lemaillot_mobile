
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/category.dart';
import '../../repositories/category_repository.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}
class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);
}
class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;

  CategoryCubit({required this.repository}) : super(CategoryInitial());

  void fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await repository.fetchCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}