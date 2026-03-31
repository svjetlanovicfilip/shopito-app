import 'package:flutter/material.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/presentation/widgets/product_list_item.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "${products.length} ${products.length == 1 ? 'rezultat' : 'rezultata'}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF121212),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductListItem(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}
