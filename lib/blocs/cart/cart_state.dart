part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final CartResponse cartResponse;

  const CartLoaded({required this.cartResponse});

  @override
  List<Object> get props => [cartResponse];
}

final class CartCleared extends CartState {}
