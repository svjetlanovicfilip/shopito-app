import 'package:flutter/material.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/presentation/widgets/M/product_card.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
