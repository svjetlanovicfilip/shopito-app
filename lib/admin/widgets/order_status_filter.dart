import 'package:flutter/material.dart';
import 'package:shopito_app/blocs/admin_orders/admin_orders_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/order_status.dart';

class OrderStatusFilter extends StatefulWidget {
  const OrderStatusFilter({super.key});

  @override
  State<OrderStatusFilter> createState() => _OrderStatusFilterState();
}

class _OrderStatusFilterState extends State<OrderStatusFilter> {
  OrderStatus? selectedStatus;
  AdminOrdersBloc get _adminOrdersBloc => getIt<AdminOrdersBloc>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedStatus = null;
              });
              _adminOrdersBloc.add(AdminOrdersFetch());
            },
            child: Container(
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    selectedStatus == null
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Sve",
                style: TextStyle(
                  color:
                      selectedStatus == null ? Color(0xFF1976D2) : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          ...OrderStatus.values.map((status) {
            bool isSelected = selectedStatus == status;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedStatus = status;
                });
                _adminOrdersBloc.add(AdminOrdersFetch(status: status.name));
              },
              child: Container(
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  OrderStatus.getTextForFilter(status),
                  style: TextStyle(
                    color: isSelected ? Color(0xFF1976D2) : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
