import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/admin/add_edit_product_screen.dart';
import 'package:shopito_app/admin/admin_product_card.dart';
import 'package:shopito_app/blocs/product/product_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/theme/colors.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final ProductBloc _productBloc = getIt<ProductBloc>();

  @override
  void initState() {
    super.initState();
    _productBloc.add(ProductFetch());
  }

  @override
  void dispose() {
    _productBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Upravljanje proizvodima",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToAddProduct(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocListener<ProductBloc, ProductState>(
                bloc: _productBloc,
                listener: (context, state) {
                  if (state is ProductOperationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    // Refresh the products list
                    _productBloc.add(ProductFetch(isRefresh: true));
                  } else if (state is ProductOperationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<ProductBloc, ProductState>(
                  bloc: _productBloc,
                  builder: (context, state) {
                    if (state is ProductLoaded) {
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // Product Stats
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildStatItem(
                                      "Ukupno",
                                      "${state.total}",
                                      Icons.inventory_2_outlined,
                                      Color(0xFF3C8D2F),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                ],
                              ),
                            ),

                            // Products List
                            Expanded(
                              child: NotificationListener<
                                ScrollUpdateNotification
                              >(
                                onNotification: (notification) {
                                  if (notification.metrics.pixels >=
                                          notification.metrics.maxScrollExtent *
                                              0.85 &&
                                      !_productBloc.areProductsLoaded) {
                                    _productBloc.add(ProductFetch());
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: state.products.length,
                                  itemBuilder: (context, index) {
                                    return AdminProductCard(
                                      product: state.products[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const Loader();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF121212),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _navigateToAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditProductScreen()),
    );
  }
}
