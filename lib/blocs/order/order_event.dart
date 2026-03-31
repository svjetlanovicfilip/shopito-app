part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderPreviewCreate extends OrderEvent {
  const OrderPreviewCreate(this.orderRequest);

  final OrderRequest orderRequest;

  @override
  List<Object> get props => [orderRequest];
}

class OrderPreviewDiscard extends OrderEvent {
  const OrderPreviewDiscard(this.orderId);

  final int orderId;

  @override
  List<Object> get props => [orderId];
}

class OrderConfirm extends OrderEvent {
  const OrderConfirm(this.orderId);

  final int orderId;

  @override
  List<Object> get props => [orderId];
}

class OrderGetUserOrders extends OrderEvent {}

class OrderGetOrderById extends OrderEvent {
  const OrderGetOrderById(this.orderId, {this.isFromNotification = false});

  final int orderId;
  final bool isFromNotification;

  @override
  List<Object> get props => [orderId];
}

class OrderMarkAsDelivered extends OrderEvent {
  const OrderMarkAsDelivered(this.orderId);

  final int orderId;

  @override
  List<Object> get props => [orderId];
}
