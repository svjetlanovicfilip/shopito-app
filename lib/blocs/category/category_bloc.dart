import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/category.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/data/repository/category_repository.dart';
import 'package:shopito_app/data/repository/product_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;

  CategoryBloc({
    required this.categoryRepository,
    required this.productRepository,
  }) : super(CategoryInitial()) {
    on<CategoryFetch>(_onCategoryFetch);
    on<ProductFetchByCategory>(_onProductFetchByCategory);
    on<CategoryCreate>(_onCategoryCreate);
    on<CategoryUpdate>(_onCategoryUpdate);
    on<CategoryDelete>(_onCategoryDelete);
  }

  List<Category> _categories = [];

  Future<void> _onCategoryFetch(
    CategoryFetch event,
    Emitter<CategoryState> emit,
  ) async {
    if (!event.isRefresh && _categories.isNotEmpty) {
      emit(CategoryLoaded(categories: List.from(_categories)));
      return;
    }

    emit(CategoryLoading());

    final result = await categoryRepository.getCategoriesWithProductCount();

    result.fold((failure) => emit(CategoryError(message: failure.message)), (
      success,
    ) {
      _categories = success;
      emit(CategoryLoaded(categories: List.from(_categories)));
    });
  }

  Future<void> _onProductFetchByCategory(
    ProductFetchByCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(ProductLoadingByCategory());

    final result = await productRepository.getProductsByCategory(
      categoryId: event.categoryId,
    );

    result.fold(
      (failure) => emit(ProductErrorByCategory(message: failure.message)),
      (success) => emit(ProductLoadedByCategory(products: success.products)),
    );
  }

  Future<void> _onCategoryCreate(
    CategoryCreate event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryOperationInProgress());

    final result = await categoryRepository.createCategory(
      category: event.category,
    );

    result.fold(
      (failure) => emit(CategoryOperationFailure(message: failure.message)),
      (success) {
        _categories.insert(0, success);
        emit(CategoryOperationSuccess(message: 'Kategorija je kreirana'));
        emit(CategoryLoaded(categories: List.from(_categories)));
      },
    );
  }

  Future<void> _onCategoryUpdate(
    CategoryUpdate event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryOperationInProgress());

    final result = await categoryRepository.updateCategory(
      category: event.category,
    );

    result.fold(
      (failure) => emit(CategoryOperationFailure(message: failure.message)),
      (success) {
        final index = _categories.indexWhere((c) => c.id == success.id);
        if (index != -1) {
          _categories[index] = success;
        }
        emit(CategoryOperationSuccess(message: 'Kategorija je ažurirana'));
        emit(CategoryLoaded(categories: List.from(_categories)));
      },
    );
  }

  Future<void> _onCategoryDelete(
    CategoryDelete event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryOperationInProgress());

    final result = await categoryRepository.deleteCategory(id: event.id);

    result.fold(
      (failure) => emit(CategoryOperationFailure(message: failure.message)),
      (success) {
        _categories.removeWhere((c) => c.id == event.id);
        emit(CategoryOperationSuccess(message: 'Kategorija je obrisana'));
        emit(CategoryLoaded(categories: List.from(_categories)));
      },
    );
  }

  void dispose() {
    _categories.clear();
  }
}
