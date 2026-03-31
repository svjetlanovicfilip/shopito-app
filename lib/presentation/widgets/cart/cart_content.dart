import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/data/models/cart_response.dart';
import 'package:shopito_app/presentation/widgets/cart/cart_item.dart';
import 'package:shopito_app/presentation/widgets/cart/cart_summary.dart';

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
    required this.cartResponse,
    required this.hasDiscount,
    required this.originalTotal,
  });

  final CartResponse cartResponse;
  final bool hasDiscount;
  final double originalTotal;

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
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stavke u korpi",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF121212),
                        ),
                      ),
                      Text(
                        "${cartResponse.totalItems} ${cartResponse.totalItems == 1 ? 'stavka' : 'stavki'}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return CartItem(item: cartResponse.items[index]);
                      },
                      itemCount: cartResponse.items.length,
                    ),
                  ),
                  hasDiscount
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Ukupno",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF121212),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${originalTotal.toStringAsFixed(2)} RSD",
                                  style: TextStyle(
                                    color: Color(0xFF8A8A8A),
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${cartResponse.total.toStringAsFixed(2)} RSD",
                                  style: TextStyle(
                                    color: Color(0xFF3C8D2F),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : CartSummary(
                        label: "Ukupno",
                        value: "${cartResponse.total.toStringAsFixed(2)} RSD",
                        isTotal: true,
                      ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(Routes.cartPersonalInfo);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3C8D2F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Nastavi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
