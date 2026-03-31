import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/models/order_status.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({super.key, required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    final status = OrderStatus.fromString(order.status);
    final isDelivered = status == OrderStatus.delivered;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDelivered ? Colors.grey.shade100 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDelivered ? Colors.green.shade100 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${order.id}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isDelivered
                                ? Colors.grey.shade600
                                : Color(0xFF121212),
                      ),
                    ),
                    if (isDelivered)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFF4CAF50,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Color(0xFF4CAF50),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Isporučeno',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: OrderStatus.getStatusColor(
                            status,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          OrderStatus.getStatusText(status),
                          style: TextStyle(
                            color: OrderStatus.getStatusColor(status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  order.createdAt.toString(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  order.orderItems
                      .map(
                        (e) =>
                            e.quantity > 1
                                ? '${e.product.name} x ${e.quantity}'
                                : e.product.name,
                      )
                      .join(", "),
                  style: TextStyle(
                    color:
                        isDelivered
                            ? Colors.grey.shade600
                            : Colors.grey.shade700,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ukupno: ${order.total.toStringAsFixed(2)} RSD",
                      style: TextStyle(
                        color:
                            isDelivered
                                ? Colors.grey.shade700
                                : Color(0xFF3C8D2F),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => context.pushNamed(
                            Routes.userOrderDetails,
                            pathParameters: {'id': order.id.toString()},
                            extra: {
                              'isAdmin': false,
                              'isFromNotification': false,
                            },
                          ),
                      child: Text(
                        "Detalji →",
                        style: TextStyle(
                          color:
                              isDelivered
                                  ? Colors.grey.shade700
                                  : Color(0xFF3C8D2F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
