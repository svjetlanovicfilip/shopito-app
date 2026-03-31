import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserOrderDetailsHeader extends StatelessWidget {
  const UserOrderDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      color: const Color(0xFF3C8D2F),
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
              child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
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
    );
  }
}
