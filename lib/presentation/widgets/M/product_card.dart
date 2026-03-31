import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/data/models/cart_item_request.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/main.dart';
import 'package:shopito_app/presentation/widgets/success_snack_bar.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.productDetails, extra: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image and discount badge
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    if (product.images.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl:
                            product.images.first.contains('http')
                                ? product.images.first
                                : '$baseImageUrl${product.images.first}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget:
                            (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                      ),
                    if (product.discount != null && product.discount! > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFCC00), // Accent color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.discount}%',
                            style: TextStyle(
                              color: Color(0xFF121212),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Product details
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.category.name,
                            style: TextStyle(
                              color: Color(0xFF6E842A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getIt<CartBloc>().add(
                              CartAddItem(
                                cartItemRequest: CartItemRequest(
                                  productId: product.id,
                                  quantity: 1,
                                ),
                              ),
                            );
                            showSuccessSnackBar(context, product.name);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color(0xFF3C8D2F),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (product.discount != null && product.discount! > 0)
                          Row(
                            children: [
                              Text(
                                product.priceWithoutDiscount?.toStringAsFixed(
                                      2,
                                    ) ??
                                    product.price.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${product.priceWithDiscount?.toStringAsFixed(2)} RSD',
                                style: TextStyle(
                                  color: Color(0xFF3C8D2F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            '${product.price.toStringAsFixed(2)} RSD',
                            style: TextStyle(
                              color: Color(0xFF3C8D2F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
