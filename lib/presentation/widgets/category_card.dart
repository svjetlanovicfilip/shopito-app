import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/data/models/category.dart';
import 'package:shopito_app/presentation/widgets/custom_image.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.categoryProducts, extra: category);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail on the left
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  category.image != null
                      ? CustomImage(
                        imageUrl: category.image!,
                        height: 64,
                        width: 64,
                      )
                      : Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.grey.shade500,
                        ),
                      ),
            ),
            const SizedBox(width: 12),

            // Title and description in the middle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Product count and arrow on the far right
            Text(
              "${category.productCount ?? 0}",
              style: const TextStyle(
                color: Color(0xFF3C8D2F),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Icon(Icons.chevron_right, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
