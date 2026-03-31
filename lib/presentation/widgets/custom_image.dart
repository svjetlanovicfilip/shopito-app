import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopito_app/main.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.imageUrl,
    this.height = 80,
    this.width,
    this.placeholder,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _getImageUrl(imageUrl),
      fit: BoxFit.cover,
      width: width ?? double.infinity,
      height: height,
      placeholder: (context, url) => placeholder ?? const SizedBox.shrink(),
      errorWidget:
          (context, url, error) => Center(
            child: Icon(
              Icons.image_not_supported,
              color: const Color.fromARGB(255, 103, 97, 97),
            ),
          ),
    );
  }

  String _getImageUrl(String imageUrl) {
    return imageUrl.contains('http') ? imageUrl : '$baseImageUrl$imageUrl';
  }
}
