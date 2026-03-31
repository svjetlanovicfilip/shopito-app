import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/repository/order_repository.dart';

part 'admin_orders_event.dart';
part 'admin_orders_state.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  final OrderRepository orderRepository;

  AdminOrdersBloc({required this.orderRepository})
    : super(AdminOrdersInitial()) {
    on<AdminOrdersFetch>(_onAdminOrdersFetch);
    on<AdminOrdersChangeStatus>(_onAdminOrdersChangeStatus);
  }

  final List<OrderResponse> _orders = [];
  int _page = 0;
  int _total = 0;
  bool _isLoading = false;
  String? _status;

  Future<void> _onAdminOrdersFetch(
    AdminOrdersFetch event,
    Emitter<AdminOrdersState> emit,
  ) async {
    if (_isLoading) return;

    if (event.status != _status) {
      clearResults();
    }

    if (event.isRefresh) {
      clearResults();
    } else {
      _status = event.status;
    }

    if (_total > 0 && _orders.length >= _total) return;

    _isLoading = true;

    if (_page == 0) {
      emit(AdminOrdersLoading());
    }

    final result = await orderRepository.getOrdersForAdmin(
      status: _status ?? event.status,
      page: _page,
    );

    result.fold(
      (failure) {
        emit(AdminOrdersFailed(failure.message));
      },
      (orders) {
        _orders.addAll(orders.orders);
        _total = orders.total;
        _page++;
        _isLoading = false;
        emit(AdminOrdersLoaded(List.from(_orders)));
      },
    );
  }

  void clearResults() {
    _orders.clear();
    _page = 0;
    _total = 0;
    _isLoading = false;
  }

  Future<void> _onAdminOrdersChangeStatus(
    AdminOrdersChangeStatus event,
    Emitter<AdminOrdersState> emit,
  ) async {
    final result = await orderRepository.changeStatusByAdmin(
      event.orderId,
      event.status,
    );

    result.fold(
      (failure) {
        emit(AdminOrdersFailed(failure.message));
      },
      (success) {
        add(AdminOrdersFetch(status: _status, isRefresh: true));
      },
    );
  }

  void dispose() {
    _orders.clear();
    _page = 0;
    _total = 0;
    _isLoading = false;
    _status = null;
  }
}
