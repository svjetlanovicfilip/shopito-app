import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/main.dart';

class ProductImageSection extends StatefulWidget {
  final Product product;

  const ProductImageSection({super.key, required this.product});

  @override
  State<ProductImageSection> createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      height: 300,
      child: Stack(
        children: [
          widget.product.images.isNotEmpty
              ? PageView.builder(
                controller: _pageController,
                physics:
                    widget.product.images.length > 1
                        ? const PageScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                itemCount: widget.product.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },

                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl:
                        widget.product.images[index].contains('http')
                            ? widget.product.images[index]
                            : '$baseImageUrl${widget.product.images[index]}',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,

                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: const Color.fromARGB(255, 103, 97, 97),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
              : Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
          if (widget.product.images.length > 1 &&
              _currentPage < widget.product.images.length - 1)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      final nextPage = _currentPage + 1;
                      if (nextPage < widget.product.images.length) {
                        _pageController.animateToPage(
                          nextPage,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF121212),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.product.images.length > 1 && _currentPage > 0)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GestureDetector(
                    onTap: () {
                      final previousPage = _currentPage - 1;
                      if (previousPage >= 0) {
                        _pageController.animateToPage(
                          previousPage,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF121212),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.product.discount != null && widget.product.discount! > 0)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCC00),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${widget.product.discount}% POPUSTA",
                  style: const TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
