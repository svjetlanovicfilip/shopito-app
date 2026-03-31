import 'package:flutter/material.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/presentation/widgets/order/order_detail_row.dart';

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({super.key, required this.user});

  final UserResponse user;

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
            "Podaci kupca",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF121212),
            ),
          ),
          const SizedBox(height: 12),
          OrderDetailRow(label: "Ime", value: user.fullname),
          OrderDetailRow(label: "Email", value: user.email),
          OrderDetailRow(label: "Telefon", value: user.phoneNumber),
        ],
      ),
    );
  }
}
