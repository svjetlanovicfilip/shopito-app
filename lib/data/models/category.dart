class Category {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final int? productCount;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.productCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['imageUrl'],
      productCount: json['productCount'],
    );
  }

  Category copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    int? productCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      productCount: productCount ?? this.productCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'image': image};
  }
}
