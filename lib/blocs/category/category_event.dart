part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryFetch extends CategoryEvent {
  final bool isRefresh;

  const CategoryFetch({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class ProductFetchByCategory extends CategoryEvent {
  final int categoryId;

  const ProductFetchByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class CategoryCreate extends CategoryEvent {
  final Category category;

  const CategoryCreate({required this.category});

  @override
  List<Object> get props => [category];
}

class CategoryUpdate extends CategoryEvent {
  final Category category;

  const CategoryUpdate({required this.category});

  @override
  List<Object> get props => [category];
}

class CategoryDelete extends CategoryEvent {
  final int id;

  const CategoryDelete({required this.id});

  @override
  List<Object> get props => [id];
}
