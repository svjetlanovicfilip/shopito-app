import 'package:flutter/material.dart';
import 'package:shopito_app/admin/widgets/change_status_button.dart';
import 'package:shopito_app/admin/widgets/customer_info_card.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/models/order_status.dart';
import 'package:shopito_app/presentation/widgets/order/delivery_info_card.dart';
import 'package:shopito_app/presentation/widgets/order/mark_as_delivered_button.dart';
import 'package:shopito_app/presentation/widgets/order/order_items_card.dart';
import 'package:shopito_app/presentation/widgets/order/order_summary_card.dart';
import 'package:shopito_app/presentation/widgets/order/status_tracker.dart'
    show StatusTracker;

class UserOrderDetailsContent extends StatelessWidget {
  const UserOrderDetailsContent({
    super.key,
    required this.order,
    required this.isAdmin,
  });

  final OrderResponse order;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      "Narudžba #${order.id}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121212),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatDate(order.createdAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: OrderStatus.getStatusColor(
                      OrderStatus.fromString(order.status),
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    OrderStatus.getStatusText(
                      OrderStatus.fromString(order.status),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: OrderStatus.getStatusColor(
                        OrderStatus.fromString(order.status),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            OrderSummaryCard(order: order),
            const SizedBox(height: 20),
            if (isAdmin) ...[
              CustomerInfoCard(user: order.user),
              const SizedBox(height: 20),
            ],
            DeliveryInfoCard(order: order),
            const SizedBox(height: 20),
            OrderItemsCard(order: order),
            const SizedBox(height: 30),
            if (!isAdmin)
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
                      "Status narudžbe",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121212),
                      ),
                    ),
                    const SizedBox(height: 16),
                    StatusTracker(currentStatus: order.status),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

            if (isAdmin)
              ChangeStatusButton(order: order)
            // Mark as delivered button (only if shipped)
            else if (order.status.toUpperCase() == 'SHIPPED')
              MarkAsDeliveredButton(orderId: order.id),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
