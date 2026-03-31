import 'package:shopito_app/data/models/product.dart';

class CartItemResponse {
  final int id;
  final Product product;
  final int quantity;
  final double subtotal;

  CartItemResponse({
    required this.id,
    required this.product,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    return CartItemResponse(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      subtotal: json['subtotal'],
    );
  }
}
