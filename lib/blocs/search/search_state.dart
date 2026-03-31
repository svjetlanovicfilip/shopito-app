part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Product> products;

  const SearchLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class SearchError extends SearchState {}
