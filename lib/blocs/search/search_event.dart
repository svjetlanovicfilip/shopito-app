part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchFetch extends SearchEvent {
  final String query;
  final int categoryId;

  const SearchFetch({required this.query, required this.categoryId});

  @override
  List<Object> get props => [query, categoryId];
}
