import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/admin_orders/admin_orders_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/order.dart';

class ChangeStatusButton extends StatelessWidget {
  const ChangeStatusButton({super.key, required this.order});

  final OrderResponse order;

  AdminOrdersBloc get _adminOrdersBloc => getIt<AdminOrdersBloc>();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> statusConfig = _getNextStatusConfig(order.status);

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
                          orderId: order.id,
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
}
