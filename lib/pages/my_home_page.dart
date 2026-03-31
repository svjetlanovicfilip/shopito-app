import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/product/product_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/presentation/widgets/XS/cart_icon.dart';
import 'package:shopito_app/presentation/widgets/products_overview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getIt<ProductBloc>().add(ProductFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with search bar - iOS style
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF3C8D2F), // Primary color
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Shop",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.goNamed(Routes.cart);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: CartIcon(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  context.pushNamed(Routes.search);
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    enabled: false, // Disable input, just for navigation
                    decoration: InputDecoration(
                      hintText: "Pretraži proizvode...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Products section
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: const Color(0xFFF5F5F5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getIt<ProductBloc>().add(ProductFetch(isRefresh: true));
                    },
                    color: Color(0xFF3C8D2F),
                    child: ProductsOverview(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
