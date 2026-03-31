part of 'admin_orders_bloc.dart';

sealed class AdminOrdersEvent extends Equatable {
  const AdminOrdersEvent();

  @override
  List<Object?> get props => [];
}

class AdminOrdersFetch extends AdminOrdersEvent {
  final String? status;
  final bool isRefresh;

  const AdminOrdersFetch({this.status, this.isRefresh = false});

  @override
  List<Object?> get props => [status, isRefresh];
}

class AdminOrdersChangeStatus extends AdminOrdersEvent {
  final int orderId;
  final String status;

  const AdminOrdersChangeStatus({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}
