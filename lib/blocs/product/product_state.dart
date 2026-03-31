part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final int total;

  const ProductLoaded({required this.products, required this.total});

  @override
  List<Object> get props => [products, total];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductLoadedById extends ProductState {
  final Product product;

  const ProductLoadedById({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductOperationInProgress extends ProductState {}

class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductOperationFailure extends ProductState {
  final String message;

  const ProductOperationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
