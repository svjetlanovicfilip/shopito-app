part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderPreviewCreationInProgress extends OrderState {}

final class OrderPreviewCreationSuccess extends OrderState {
  const OrderPreviewCreationSuccess(this.orderResponse);

  final OrderResponse orderResponse;

  @override
  List<Object> get props => [orderResponse];
}

final class OrderPreviewCreationFailed extends OrderState {
  const OrderPreviewCreationFailed(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

final class OrderPreviewDiscardSuccess extends OrderState {}

final class OrderConfirmationInProgress extends OrderState {}

final class OrderConfirmationSuccess extends OrderState {
  const OrderConfirmationSuccess(this.orderResponse);

  final OrderResponse orderResponse;

  @override
  List<Object> get props => [orderResponse];
}

final class OrderConfirmationFailed extends OrderState {
  const OrderConfirmationFailed(this.error);

  final String error;
}

class OrderUserOrdersLoading extends OrderState {}

class OrderUserOrdersLoaded extends OrderState {
  const OrderUserOrdersLoaded(this.orders);

  final List<OrderResponse> orders;

  @override
  List<Object> get props => [orders];
}

class OrderMarkAsDeliveredLoading extends OrderState {}

class OrderMarkAsDeliveredSuccess extends OrderState {}

class OrderMarkAsDeliveredFailed extends OrderState {
  const OrderMarkAsDeliveredFailed(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

class OrderUserOrderDetailsLoading extends OrderState {}

class OrderByIdLoaded extends OrderState {
  const OrderByIdLoaded(this.order);

  final OrderResponse order;

  @override
  List<Object> get props => [order];
}
