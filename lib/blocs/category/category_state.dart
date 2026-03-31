part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductLoadingByCategory extends CategoryState {}

class ProductLoadedByCategory extends CategoryState {
  final List<Product> products;

  const ProductLoadedByCategory({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductErrorByCategory extends CategoryState {
  final String message;

  const ProductErrorByCategory({required this.message});

  @override
  List<Object> get props => [message];
}

class CategoryOperationInProgress extends CategoryState {}

class CategoryOperationSuccess extends CategoryState {
  final String message;

  const CategoryOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class CategoryOperationFailure extends CategoryState {
  final String message;

  const CategoryOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
