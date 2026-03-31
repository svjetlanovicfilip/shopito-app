import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/cart_item_request.dart';
import 'package:shopito_app/data/models/cart_item_response.dart';
import 'package:shopito_app/data/models/cart_response.dart';
import 'package:shopito_app/data/repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  List<CartItemResponse> cartItems = [];

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<CartGetItems>(_onCartGetItems);
    on<CartAddItem>(_onCartAddItem);
    on<CartClear>(_onCartClear);
    on<CartUpdateItem>(_onCartUpdateItem);
    on<CartRemoveItem>(_onCartRemoveItem);
  }

  Future<void> _onCartGetItems(
    CartGetItems event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await cartRepository.getCart();
    result.fold(
      (failure) {
        // emit(CartError(failure.message));
      },
      (cartResponse) {
        cartItems = cartResponse.items;
        emit(CartLoaded(cartResponse: cartResponse));
      },
    );
  }

  Future<void> _onCartAddItem(
    CartAddItem event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await cartRepository.addToCart(event.cartItemRequest);
    result.fold(
      (failure) {
        // emit(CartError(failure.message));
      },
      (cartResponse) {
        cartItems = cartResponse.items;
        emit(CartLoaded(cartResponse: cartResponse));
      },
    );
  }

  Future<void> _onCartClear(CartClear event, Emitter<CartState> emit) async {
    cartItems.clear();
    emit(CartCleared());
  }

  Future<void> _onCartUpdateItem(
    CartUpdateItem event,
    Emitter<CartState> emit,
  ) async {
    final result = await cartRepository.updateCartItem(
      event.cartItemId,
      event.quantity,
    );
    result.fold((failure) {}, (cartResponse) {
      if (cartResponse != null) {
        emit(CartLoaded(cartResponse: cartResponse));
      } else {
        emit(CartCleared());
      }
    });
  }

  Future<void> _onCartRemoveItem(
    CartRemoveItem event,
    Emitter<CartState> emit,
  ) async {
    final result = await cartRepository.removeCartItem(event.cartItemId);
    result.fold((failure) {}, (cartResponse) {
      if (cartResponse != null) {
        emit(CartLoaded(cartResponse: cartResponse));
      } else {
        emit(CartCleared());
      }
    });
  }
}
