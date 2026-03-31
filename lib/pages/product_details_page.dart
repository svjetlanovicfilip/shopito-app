import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/cart_item_request.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/presentation/widgets/product/product_details_header.dart';
import 'package:shopito_app/presentation/widgets/product/product_image_section.dart';
import 'package:shopito_app/presentation/widgets/product/product_video_section.dart';
import 'package:shopito_app/presentation/widgets/success_snack_bar.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ProductDetailsHeader(),

            // Product content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image section
                    ProductImageSection(product: widget.product),

                    // Product info section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF6E842A,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.product.category.name,
                              style: const TextStyle(
                                color: Color(0xFF6E842A),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Product name
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF121212),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Price
                          Row(
                            children: [
                              if (widget.product.discount != null &&
                                  widget.product.discount! > 0) ...[
                                Text(
                                  "${widget.product.priceWithoutDiscount?.toStringAsFixed(2)} RSD",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                "${widget.product.priceWithDiscount?.toStringAsFixed(2)} RSD",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3C8D2F),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Stock info
                          Row(
                            children: [
                              Icon(
                                Icons.inventory,
                                color:
                                    widget.product.quantity > 0
                                        ? const Color(0xFF3C8D2F)
                                        : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.product.quantity > 0
                                    ? "Na lageru: ${widget.product.quantity} kom"
                                    : "Nema na lageru",
                                style: TextStyle(
                                  color:
                                      widget.product.quantity > 0
                                          ? const Color(0xFF3C8D2F)
                                          : Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Video section (below name, above price)
                          if (widget.product.videoUrl != null) ...[
                            ProductVideoSection(
                              videoUrl: widget.product.videoUrl!,
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Description
                          if (widget.product.description != null &&
                              widget.product.description!.isNotEmpty) ...[
                            const Text(
                              "Opis proizvoda",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF121212),
                              ),
                            ),
                            const SizedBox(height: 8),
                            HtmlWidget(
                              widget.product.description!,
                              textStyle: const TextStyle(
                                fontSize: 14,
                                // color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF3C8D2F),
            ),
            margin: const EdgeInsets.only(left: 33),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: quantity > 1 ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "$quantity",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (quantity < widget.product.quantity) {
                      setState(() {
                        quantity++;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color:
                          quantity < widget.product.quantity
                              ? Colors.white
                              : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Add to Cart button
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showSuccessSnackBar(
                    context,
                    "$quantity x ${widget.product.name} dodano u korpu!",
                  );
                  getIt<CartBloc>().add(
                    CartAddItem(
                      cartItemRequest: CartItemRequest(
                        productId: widget.product.id,
                        quantity: quantity,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C8D2F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Dodaj u korpu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
