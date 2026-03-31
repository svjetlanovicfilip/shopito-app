import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.label,
    required this.value,
    required this.isTotal,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: Color(0xFF121212),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Color(0xFF3C8D2F) : Color(0xFF121212),
            ),
          ),
        ],
      ),
    );
  }
}
