import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/data/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<ProductFetch>(_onProductFetch);
    on<ProductFetchById>(_onProductFetchById);
    on<ProductCreate>(_onProductCreate);
    on<ProductUpdate>(_onProductUpdate);
    on<ProductDelete>(_onProductDelete);
  }

  final ProductRepository productRepository;

  bool get areProductsLoaded =>
      _total > 0 && _products.isNotEmpty && _products.length >= _total;

  int _page = 0;
  int _total = 0;
  final List<Product> _products = [];
  bool _isLoading = false;

  Future<void> _onProductFetch(
    ProductFetch event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoading || _isLoading) return;

    _isLoading = true;

    if (event.isRefresh) {
      _resetState();
    }

    if (_total > 0 && _page * 24 >= _total) return;

    if (_page == 0) {
      emit(ProductLoading());
    }

    final result = await productRepository.getProducts(page: _page);

    result.fold(
      (failure) {
        emit(ProductError(message: failure.message));
        _isLoading = false;
      },
      (success) {
        _isLoading = false;
        _products.addAll(success.products);
        _total = success.total;
        _page++;
        emit(ProductLoaded(products: List.from(_products), total: _total));
      },
    );
  }

  Future<void> _onProductFetchById(
    ProductFetchById event,
    Emitter<ProductState> emit,
  ) async {
    final product = _products.where((p) => p.id == event.id).firstOrNull;

    if (product != null) {
      emit(ProductLoadedById(product: product));
      return;
    }

    final result = await productRepository.getProductById(id: event.id);

    result.fold((failure) {}, (success) {
      emit(ProductLoadedById(product: success));
    });
  }

  Future<void> _onProductCreate(
    ProductCreate event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductOperationInProgress());

    final result = await productRepository.createProduct(
      product: event.product,
    );

    result.fold(
      (failure) => emit(ProductOperationFailure(message: failure.message)),
      (success) {
        _products.insert(0, success);
        _total++;
        emit(ProductOperationSuccess(message: 'Proizvod je uspješno kreiran'));
        emit(ProductLoaded(products: List.from(_products), total: _total));
      },
    );
  }

  Future<void> _onProductUpdate(
    ProductUpdate event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductOperationInProgress());

    final result = await productRepository.updateProduct(
      product: event.product,
    );

    result.fold(
      (failure) => emit(ProductOperationFailure(message: failure.message)),
      (success) {
        // Update local product list
        final index = _products.indexWhere((p) => p.id == event.product.id);
        if (index != -1) {
          _products[index] = success;
        }
        emit(ProductOperationSuccess(message: 'Proizvod je uspješno ažuriran'));
        emit(ProductLoaded(products: List.from(_products), total: _total));
      },
    );
  }

  Future<void> _onProductDelete(
    ProductDelete event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductOperationInProgress());

    final result = await productRepository.deleteProduct(id: event.id);

    result.fold(
      (failure) => emit(ProductOperationFailure(message: failure.message)),
      (success) {
        _products.removeWhere((p) => p.id == event.id);
        _total--;
        emit(ProductOperationSuccess(message: 'Proizvod je uspješno obrisan'));
        emit(ProductLoaded(products: List.from(_products), total: _total));
      },
    );
  }

  void _resetState() {
    _page = 0;
    _products.clear();
    _total = 0;
  }

  void dispose() {
    _products.clear();
    _total = 0;
    _page = 0;
    _isLoading = false;
  }
}
