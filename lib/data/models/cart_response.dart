import 'package:shopito_app/data/models/cart_item_response.dart';

class CartResponse {
  final int id;
  final List<CartItemResponse> items;
  final double total;
  final int totalItems;

  CartResponse({
    required this.id,
    required this.items,
    required this.total,
    required this.totalItems,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      id: json['id'],
      items:
          List.from(
            json['items'],
          ).map((e) => CartItemResponse.fromJson(e)).toList(),
      total: json['total'],
      totalItems: json['totalItems'],
    );
  }
}
