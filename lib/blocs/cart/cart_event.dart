part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartAddItem extends CartEvent {
  final CartItemRequest cartItemRequest;

  const CartAddItem({required this.cartItemRequest});

  @override
  List<Object> get props => [cartItemRequest];
}

class CartUpdateItem extends CartEvent {
  final int cartItemId;
  final int quantity;

  const CartUpdateItem({required this.cartItemId, required this.quantity});

  @override
  List<Object> get props => [cartItemId, quantity];
}

class CartRemoveItem extends CartEvent {
  final int cartItemId;

  const CartRemoveItem({required this.cartItemId});

  @override
  List<Object> get props => [cartItemId];
}

class CartGetItems extends CartEvent {}

class CartClear extends CartEvent {}
