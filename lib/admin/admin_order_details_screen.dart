import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/admin_orders/admin_orders_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/models/order_status.dart';
import 'package:shopito_app/presentation/widgets/order/order_detail_row.dart';

class AdminOrderDetailsScreen extends StatefulWidget {
  const AdminOrderDetailsScreen({super.key, required this.order});

  final OrderResponse order;

  @override
  State<AdminOrderDetailsScreen> createState() =>
      _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  final AdminOrdersBloc _adminOrdersBloc = getIt<AdminOrdersBloc>();
  late OrderResponse currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C8D2F),
      body: SafeArea(
        child: BlocListener<AdminOrdersBloc, AdminOrdersState>(
          bloc: _adminOrdersBloc,
          listener: (context, state) {
            if (state is AdminOrdersLoaded) {
              // Status change successful - find the updated order or show success
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Status je uspešno promenjen!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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

              // Refresh or go back to previous screen
              Future.delayed(Duration(seconds: 1), () {
                context.pop();
              });
            } else if (state is AdminOrdersFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 24),
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
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      "Detalji narudžbe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: const Color(0xFFF5F5F5),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID and Status Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Narudžba #${currentOrder.id}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF121212),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _formatDate(currentOrder.createdAt),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: OrderStatus.getStatusColor(
                                  OrderStatus.fromString(currentOrder.status),
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                OrderStatus.getTextForFilter(
                                  OrderStatus.fromString(currentOrder.status),
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: OrderStatus.getStatusColor(
                                    OrderStatus.fromString(currentOrder.status),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Order Summary Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sažetak narudžbe",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF121212),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OrderDetailRow(
                                label: "Ukupno",
                                value:
                                    "${currentOrder.total.toStringAsFixed(2)} RSD",
                              ),
                              OrderDetailRow(
                                label: "Podzbroj",
                                value:
                                    "${currentOrder.subtotal.toStringAsFixed(2)} RSD",
                              ),
                              OrderDetailRow(
                                label: "Dostava",
                                value:
                                    "${currentOrder.deliveryCost.toStringAsFixed(2)} RSD",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Customer Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Podaci kupca",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF121212),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OrderDetailRow(
                                label: "Ime",
                                value: currentOrder.user.fullname,
                              ),
                              OrderDetailRow(
                                label: "Email",
                                value: currentOrder.user.email,
                              ),
                              OrderDetailRow(
                                label: "Telefon",
                                value: currentOrder.user.phoneNumber,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Delivery Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Adresa dostave",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF121212),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OrderDetailRow(
                                label: "Adresa",
                                value: currentOrder.address.addressName,
                              ),
                              OrderDetailRow(
                                label: "Grad",
                                value: currentOrder.address.cityName,
                              ),
                              OrderDetailRow(
                                label: "Država",
                                value: currentOrder.address.countryName,
                              ),
                              OrderDetailRow(
                                label: "Poštanski kod",
                                value: currentOrder.postalCode,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Order Items Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Stavke narudžbe",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF121212),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...currentOrder.orderItems.map(
                                (item) => Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF3C8D2F),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          "${item.quantity}x",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF121212),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${(item.price * item.quantity).toStringAsFixed(2)} RSD",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF3C8D2F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Dynamic Status Change Button
                        _buildStatusChangeButton(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChangeButton() {
    // Get next status and button configuration based on current status
    Map<String, dynamic> statusConfig = _getNextStatusConfig(
      currentOrder.status,
    );

    if (statusConfig['nextStatus'] == null) {
      // No further status changes available
      return Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Nema dostupnih promjena statusa",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    return BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
      bloc: _adminOrdersBloc,
      builder: (context, state) {
        bool isLoading = state is AdminOrdersLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      _adminOrdersBloc.add(
                        AdminOrdersChangeStatus(
                          orderId: currentOrder.id,
                          status: statusConfig['nextStatus'],
                        ),
                      );
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3C8D2F),
              foregroundColor: Colors.white,
              elevation: 0,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                isLoading
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(statusConfig['icon'], size: 20),
                        SizedBox(width: 8),
                        Text(
                          statusConfig['text'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _getNextStatusConfig(String currentStatus) {
    switch (currentStatus.toUpperCase()) {
      case 'PENDING':
        return {
          'nextStatus': 'CONFIRMED',
          'text': 'Potvrdi narudžbu',
          'icon': Icons.check_circle_outline,
        };
      case 'CONFIRMED':
        return {
          'nextStatus': 'PROCESSING',
          'text': 'Stavi u obradu',
          'icon': Icons.hourglass_empty,
        };
      case 'PROCESSING':
        return {
          'nextStatus': 'SHIPPED',
          'text': 'Označi kao poslano',
          'icon': Icons.local_shipping,
        };
      case 'SHIPPED':
        return {
          'nextStatus': 'DELIVERED',
          'text': 'Označi kao dostavljeno',
          'icon': Icons.done_all,
        };
      case 'DELIVERED':
      case 'CANCELLED':
      default:
        return {'nextStatus': null, 'text': '', 'icon': Icons.block};
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
