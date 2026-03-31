import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<OrderPreviewCreate>(_onOrderPreviewCreate);
    on<OrderPreviewDiscard>(_onOrderPreviewDiscard);
    on<OrderConfirm>(_onOrderConfirm);
    on<OrderGetUserOrders>(_onOrderGetUserOrders);
    on<OrderGetOrderById>(_onOrderGetOrderById);
    on<OrderMarkAsDelivered>(_onOrderMarkAsDelivered);
  }

  final OrderRepository orderRepository;

  OrderResponse? orderPreview;
  List<OrderResponse> _userOrders = [];

  Future<void> _onOrderPreviewCreate(
    OrderPreviewCreate event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderPreviewCreationInProgress());

    final either = await orderRepository.createOrderPreview(event.orderRequest);

    either.fold(
      (failure) => emit(OrderPreviewCreationFailed(failure.message)),
      (success) {
        orderPreview = success;
        emit(OrderPreviewCreationSuccess(success));
      },
    );
  }

  Future<void> _onOrderConfirm(
    OrderConfirm event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderConfirmationInProgress());

    final either = await orderRepository.confirmOrder(event.orderId);

    if (either.isLeft) {
      emit(OrderConfirmationFailed(either.left.message));
      return;
    }

    final success = either.right;
    emit(OrderConfirmationSuccess(success));

    add(OrderGetUserOrders());
  }

  Future<void> _onOrderPreviewDiscard(
    OrderPreviewDiscard event,
    Emitter<OrderState> emit,
  ) async {
    final either = await orderRepository.discardOrderPreview(event.orderId);

    either.fold((failure) {}, (success) {
      orderPreview = null;
      emit(OrderPreviewDiscardSuccess());
    });
  }

  Future<void> _onOrderGetOrderById(
    OrderGetOrderById event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderUserOrderDetailsLoading());
    final either = await orderRepository.getOrderById(event.orderId);

    if (either.isLeft) {
      return;
    }

    final order = either.right;
    emit(OrderByIdLoaded(order));

    if (event.isFromNotification) {
      _userOrders.removeWhere((order) => order.id == event.orderId);
      _userOrders.insert(0, order);
      emit(OrderUserOrdersLoaded(List.from(_userOrders)));
    }
  }

  Future<void> _onOrderGetUserOrders(
    OrderGetUserOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderUserOrdersLoading());
    final either = await orderRepository.getUserOrders();

    either.fold((failure) => {}, (orders) {
      _userOrders = orders;
      emit(OrderUserOrdersLoaded(orders));
    });
  }

  Future<void> _onOrderMarkAsDelivered(
    OrderMarkAsDelivered event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderMarkAsDeliveredLoading());

    final either = await orderRepository.markOrderAsDelivered(event.orderId);

    if (either.isLeft) {
      emit(OrderMarkAsDeliveredFailed(either.left.message));
      return;
    }

    emit(OrderMarkAsDeliveredSuccess());

    add(OrderGetOrderById(event.orderId, isFromNotification: true));
  }
}
