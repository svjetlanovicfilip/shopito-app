import 'package:flutter/material.dart';
import 'package:shopito_app/data/models/order_status.dart';

class StatusTracker extends StatelessWidget {
  const StatusTracker({super.key, required this.currentStatus});

  final String currentStatus;

  @override
  Widget build(BuildContext context) {
    final statusList = OrderStatus.getStatusesForOrderDetails();
    final statusLabels =
        statusList.map((e) => OrderStatus.getTextForFilter(e)).toList();

    final currentStatusIndex = statusList.indexOf(
      OrderStatus.fromString(currentStatus),
    );

    return Column(
      children:
          statusList.asMap().entries.map((entry) {
            final index = entry.key;
            final isCompleted = index <= currentStatusIndex;
            final isCurrent = index == currentStatusIndex;

            return Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color:
                        isCompleted ? Color(0xFF3C8D2F) : Colors.grey.shade300,
                    shape: BoxShape.circle,
                    border:
                        isCurrent
                            ? Border.all(color: Color(0xFF3C8D2F), width: 2)
                            : null,
                  ),
                  child:
                      isCompleted
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusLabels[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isCurrent ? FontWeight.w600 : FontWeight.normal,
                      color:
                          isCompleted
                              ? Color(0xFF121212)
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
                if (index < statusList.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color:
                        index < currentStatusIndex
                            ? Color(0xFF3C8D2F)
                            : Colors.grey.shade300,
                    margin: EdgeInsets.only(left: 11, top: 8),
                  ),
              ],
            );
          }).toList(),
    );
  }
}
