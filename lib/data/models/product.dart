import 'package:shopito_app/data/models/category.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final Category category;
  final int quantity;
  final String? videoUrl;
  final int? discount;
  final List<String> images;
  final double? priceWithDiscount;
  final double? priceWithoutDiscount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
    this.videoUrl,
    this.discount,
    this.images = const [],
    this.priceWithDiscount,
    this.priceWithoutDiscount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: Category.fromJson(json['category']),
      quantity: json['quantity'],
      videoUrl: json['video_url'],
      discount: json['discount'],
      images:
          List.from(json['images']).map((e) => e['url'].toString()).toList(),
      priceWithDiscount: json['priceWithDiscount'],
      priceWithoutDiscount: json['priceWithoutDiscount'] ?? json['price'],
    );
  }

  Product copyWith({
    String? name,
    String? description,
    double? price,
    Category? category,
    int? quantity,
    String? videoUrl,
    int? discount,
    List<String>? images,
    double? priceWithDiscount,
    double? priceWithoutDiscount,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      videoUrl: videoUrl ?? this.videoUrl,
      discount: discount ?? this.discount,
      images: images ?? this.images,
      priceWithDiscount: priceWithDiscount ?? this.priceWithDiscount,
      priceWithoutDiscount: priceWithoutDiscount ?? this.priceWithoutDiscount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'categoryId': category.id,
      'quantity': quantity,
      'video_url': videoUrl,
      'discount': discount,
      'imageUrls': images,
    };
  }
}
