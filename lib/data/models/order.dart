import 'package:shopito_app/data/models/product.dart';

class OrderRequest {
  final String status;
  final String postalCode;
  final String countryName;
  final String cityName;
  final String addressName;
  final int? userId;
  final List<OrderItem> orderItems;

  OrderRequest({
    required this.status,
    required this.postalCode,
    required this.countryName,
    required this.cityName,
    required this.addressName,
    required this.orderItems,
    this.userId,
  });

  Map<String, dynamic> toJson(int userId) {
    return {
      'status': status,
      'postalCode': postalCode,
      'countryName': countryName,
      'cityName': cityName,
      'addressName': addressName,
      'userId': userId,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int productId;
  final int quantity;
  final String comment;
  final int discount;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.comment,
    required this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'comment': comment,
      'discount': discount,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      quantity: json['quantity'],
      comment: json['comment'],
      discount: json['discount'],
    );
  }
}

class OrderResponse {
  final int id;
  final double subtotal;
  final double deliveryCost;
  final double total;
  final String status;
  final DateTime createdAt;
  final String postalCode;
  final AddressResponse address;
  final UserResponse user;
  final List<OrderItemResponse> orderItems;

  OrderResponse({
    required this.id,
    required this.subtotal,
    required this.deliveryCost,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.postalCode,
    required this.address,
    required this.user,
    required this.orderItems,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'],
      subtotal: json['subtotal'],
      deliveryCost: json['deliveryCost'],
      total: json['total'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      postalCode: json['postalCode'],
      address: AddressResponse.fromJson(json['address']),
      user: UserResponse.fromJson(json['user']),
      orderItems:
          List.from(
            json['orderItems'],
          ).map((item) => OrderItemResponse.fromJson(item)).toList(),
    );
  }

  OrderResponse copyWith({String? status}) {
    return OrderResponse(
      id: id,
      subtotal: subtotal,
      deliveryCost: deliveryCost,
      total: total,
      status: status ?? this.status,
      createdAt: createdAt,
      postalCode: postalCode,
      address: address,
      user: user,
      orderItems: orderItems,
    );
  }
}

class OrderItemResponse {
  final int id;
  final double price;
  final int quantity;
  final String comment;
  final int discount;
  final Product product;

  OrderItemResponse({
    required this.id,
    required this.price,
    required this.quantity,
    required this.comment,
    required this.discount,
    required this.product,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
      id: json['id'],
      price: json['price'],
      quantity: json['quantity'],
      comment: json['comment'],
      discount: json['discount'],
      product: Product.fromJson(json['product']),
    );
  }
}

class AddressResponse {
  final int id;
  final String addressName;
  final String cityName;
  final String countryName;

  AddressResponse({
    required this.id,
    required this.addressName,
    required this.cityName,
    required this.countryName,
  });

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      id: json['id'],
      addressName: json['name'],
      cityName: json['city']['name'],
      countryName: json['city']['country']['name'],
    );
  }
}

class UserResponse {
  final int? id;
  final String fullname;
  final String email;
  final String phoneNumber;

  UserResponse({
    this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'fullname': fullname, 'email': email, 'phoneNumber': phoneNumber};
  }
}
