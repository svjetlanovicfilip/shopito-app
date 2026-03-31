part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductFetch extends ProductEvent {
  final bool isRefresh;

  const ProductFetch({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class ProductFetchById extends ProductEvent {
  final int id;

  const ProductFetchById({required this.id});

  @override
  List<Object> get props => [id];
}

class ProductCreate extends ProductEvent {
  final Product product;

  const ProductCreate({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductUpdate extends ProductEvent {
  final Product product;

  const ProductUpdate({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductDelete extends ProductEvent {
  final int id;

  const ProductDelete({required this.id});

  @override
  List<Object> get props => [id];
}
