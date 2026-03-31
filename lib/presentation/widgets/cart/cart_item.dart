import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/cart_item_response.dart';
import 'package:shopito_app/main.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.item});

  final CartItemResponse item;

  CartBloc get _cartBloc => getIt<CartBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  item.product.images.first.contains('http')
                      ? item.product.images.first
                      : '$baseImageUrl${item.product.images.first}',
                ),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFFFFCC00),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${item.product.discount}%",
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.product.category.name,
                      style: TextStyle(
                        color: Color(0xFF6E842A),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => _cartBloc.add(
                            CartRemoveItem(cartItemId: item.id),
                          ),
                      child: Container(
                        padding: EdgeInsets.all(4),

                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),
                Text(
                  item.product.name,
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                (item.product.discount != null && item.product.discount! > 0)
                    ? Row(
                      children: [
                        Text(
                          "${item.product.priceWithoutDiscount} RSD",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${item.product.priceWithDiscount} RSD",
                          style: TextStyle(
                            color: Color(0xFF3C8D2F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      "${item.product.priceWithoutDiscount} RSD",
                      style: TextStyle(
                        color: Color(0xFF3C8D2F),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                const SizedBox(width: 6),
                // Quantity controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 12,
                  children: [
                    GestureDetector(
                      onTap:
                          () => _cartBloc.add(
                            CartUpdateItem(
                              cartItemId: item.id,
                              quantity: item.quantity - 1,
                            ),
                          ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: Color(0xFF121212),
                        ),
                      ),
                    ),
                    Text(
                      "${item.quantity}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF121212),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    GestureDetector(
                      onTap:
                          () => _cartBloc.add(
                            CartUpdateItem(
                              cartItemId: item.id,
                              quantity: item.quantity + 1,
                            ),
                          ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFF3C8D2F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.add, size: 16, color: Colors.white),
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
