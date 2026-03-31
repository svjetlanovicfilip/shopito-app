part of 'admin_orders_bloc.dart';

sealed class AdminOrdersState extends Equatable {
  const AdminOrdersState();

  @override
  List<Object> get props => [];
}

final class AdminOrdersInitial extends AdminOrdersState {}

final class AdminOrdersLoading extends AdminOrdersState {}

final class AdminOrdersLoaded extends AdminOrdersState {
  const AdminOrdersLoaded(this.orders);

  final List<OrderResponse> orders;

  @override
  List<Object> get props => [orders];
}

final class AdminOrdersFailed extends AdminOrdersState {
  const AdminOrdersFailed(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
