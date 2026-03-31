import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/admin_orders/admin_orders_bloc.dart';
import 'package:shopito_app/blocs/order/order_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';
import 'package:shopito_app/presentation/widgets/order/user_order_details_content.dart';
import 'package:shopito_app/presentation/widgets/order/user_order_details_header.dart';

class UserOrderDetailsScreen extends StatefulWidget {
  const UserOrderDetailsScreen({
    super.key,
    required this.orderId,
    this.isFromNotification = false,
    this.isAdmin = false,
  });

  final int orderId;
  final bool isFromNotification;
  final bool isAdmin;

  @override
  State<UserOrderDetailsScreen> createState() => _UserOrderDetailsScreenState();
}

class _UserOrderDetailsScreenState extends State<UserOrderDetailsScreen> {
  final OrderBloc _orderBloc = getIt<OrderBloc>();
  final _globalKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _orderBloc.add(
      OrderGetOrderById(
        widget.orderId,
        isFromNotification: widget.isFromNotification,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: SafeArea(
        child: BlocListener<AdminOrdersBloc, AdminOrdersState>(
          bloc: getIt<AdminOrdersBloc>(),
          listener: (context, state) {
            if (state is AdminOrdersLoaded) {
              context.pop();
            }
          },
          child: BlocConsumer<OrderBloc, OrderState>(
            bloc: _orderBloc,
            buildWhen:
                (previous, current) =>
                    current is OrderUserOrderDetailsLoading ||
                    current is OrderByIdLoaded,
            listenWhen:
                (previous, current) =>
                    current is OrderMarkAsDeliveredLoading ||
                    current is OrderMarkAsDeliveredSuccess ||
                    current is OrderMarkAsDeliveredFailed,
            listener: (context, state) {
              if (state is OrderMarkAsDeliveredLoading) {
                showOverlay();
              } else if (state is OrderMarkAsDeliveredSuccess) {
                _removeOverlay();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Narudžba je uspešno označena kao isporučena!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(16),
                    duration: Duration(seconds: 3),
                  ),
                );
                context.pop();
              } else if (state is OrderMarkAsDeliveredFailed) {
                _removeOverlay();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Greška: ${state.error}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Color(0xFFE53E3E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(16),
                    duration: Duration(seconds: 4),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is OrderByIdLoaded) {
                return Column(
                  children: [
                    const UserOrderDetailsHeader(),
                    Expanded(
                      child: UserOrderDetailsContent(
                        order: state.order,
                        isAdmin: widget.isAdmin,
                      ),
                    ),
                  ],
                );
              }

              return Loader();
            },
          ),
        ),
      ),
    );
  }

  void showOverlay() {
    // Ukloni postojeći overlay ako postoji
    _removeOverlay();

    final ctx = _globalKey.currentContext ?? context;
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {}, // Empty callback to prevent interaction
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Loader(),
      ),
    );
    _overlayEntry = OverlayEntry(builder: (context) => child);
    Overlay.of(ctx).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
