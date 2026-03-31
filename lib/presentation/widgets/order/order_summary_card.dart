import 'package:flutter/material.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/presentation/widgets/order/order_detail_row.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            value: "${order.total.toStringAsFixed(2)} RSD",
          ),
          OrderDetailRow(
            label: "Cijena bez dostave",
            value: "${order.subtotal.toStringAsFixed(2)} RSD",
          ),
          OrderDetailRow(
            label: "Dostava",
            value: "${order.deliveryCost.toStringAsFixed(2)} RSD",
          ),
        ],
      ),
    );
  }
}
