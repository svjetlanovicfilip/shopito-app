import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/admin/add_edit_category_screen.dart';
import 'package:shopito_app/admin/admin_category_card.dart';
import 'package:shopito_app/blocs/category/category_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/theme/colors.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final CategoryBloc _categoryBloc = getIt<CategoryBloc>();

  @override
  void initState() {
    super.initState();
    _categoryBloc.add(const CategoryFetch());
  }

  @override
  void dispose() {
    _categoryBloc.dispose();
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Upravljanje kategorijama',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToAddCategory,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocListener<CategoryBloc, CategoryState>(
                bloc: _categoryBloc,
                listener: (context, state) {
                  if (state is CategoryOperationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    _categoryBloc.add(const CategoryFetch(isRefresh: true));
                  } else if (state is CategoryOperationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  bloc: _categoryBloc,
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
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
                                      'Ukupno',
                                      '${state.categories.length}',
                                      Icons.category_outlined,
                                      const Color(0xFF3C8D2F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: state.categories.length,
                                itemBuilder: (context, index) {
                                  return AdminCategoryCard(
                                    category: state.categories[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is CategoryError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
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
          style: const TextStyle(
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

  void _navigateToAddCategory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditCategoryScreen()),
    );

    if (result == true) {
      _categoryBloc.add(const CategoryFetch(isRefresh: true));
    }
  }
}
