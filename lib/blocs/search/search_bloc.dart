import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/data/repository/search_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(SearchInitial()) {
    on<SearchFetch>(_onSearchFetch, transformer: debounce());
  }

  EventTransformer<Event> debounce<Event>({
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }

  int _page = 0;
  int _total = 0;
  final List<Product> _products = [];
  String _query = '';
  int _categoryId = -1;

  Future<void> _onSearchFetch(
    SearchFetch event,
    Emitter<SearchState> emit,
  ) async {
    if (_query != event.query || _categoryId != event.categoryId) {
      _page = 0;
      _total = 0;
      _products.clear();
      _query = event.query;
      _categoryId = event.categoryId;
    }

    if (_total > 0 && _products.length >= _total) return;

    if (_query.length < 3) {
      emit(SearchLoaded(products: []));
      return;
    }

    if (_page == 0) {
      emit(SearchLoading());
    }

    final result = await searchRepository.searchProducts(
      query: event.query,
      categoryId: event.categoryId,
      page: _page,
      size: 24, //default size
    );

    result.fold((failure) => emit(SearchError()), (data) {
      _products.addAll(data.products);
      _total = data.total;
      _page++;

      emit(SearchLoaded(products: List.from(_products)));
    });
  }

  void clearSearch() {
    _page = 0;
    _total = 0;
    _products.clear();
    _query = '';
    _categoryId = -1;
  }
}
