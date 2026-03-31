import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/category/category_bloc.dart';
import 'package:shopito_app/blocs/search/search_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/category/category_filter_item.dart';

class CategoryFilters extends StatefulWidget {
  const CategoryFilters({super.key, required this.onCategorySelected});

  final Function(int) onCategorySelected;

  @override
  State<CategoryFilters> createState() => _CategoryFiltersState();
}

class _CategoryFiltersState extends State<CategoryFilters> {
  final categoryBloc = getIt<CategoryBloc>();
  int selectedCategory = -1;
  final SearchBloc searchBloc = getIt<SearchBloc>();

  @override
  void initState() {
    super.initState();
    categoryBloc.add(CategoryFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      bloc: categoryBloc,

      builder: (context, state) {
        if (state is CategoryLoaded) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children:
                    state.categories.map((category) {
                      bool isSelected = selectedCategory == category.id;

                      return CategoryFilterItem(
                        category: category,
                        isSelected: isSelected,
                        onTap: () {
                          if (isSelected) {
                            setState(() {
                              selectedCategory = -1;
                            });
                            widget.onCategorySelected(-1);
                          } else {
                            setState(() {
                              selectedCategory = category.id;
                            });
                            widget.onCategorySelected(category.id);
                          }
                        },
                      );
                    }).toList(),
              ),
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
