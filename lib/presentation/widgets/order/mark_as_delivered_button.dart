import 'package:flutter/material.dart';
import 'package:shopito_app/blocs/order/order_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';

class MarkAsDeliveredButton extends StatelessWidget {
  const MarkAsDeliveredButton({super.key, required this.orderId});

  final int orderId;

  OrderBloc get _orderBloc => getIt<OrderBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            "Primio sam pošiljku",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF121212),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ako ste primili pošiljku na adresi, možete je označiti kao dostavljenu.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _orderBloc.add(OrderMarkAsDelivered(orderId)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 0,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done_all, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Označi kao dostavljeno",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
