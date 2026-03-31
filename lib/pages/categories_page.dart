import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/category/category_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';
import 'package:shopito_app/presentation/widgets/category_card.dart';
import 'package:shopito_app/presentation/widgets/header.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String selectedCategory = "Sve kategorije";
  final categoryBloc = getIt<CategoryBloc>();

  @override
  void initState() {
    super.initState();
    categoryBloc.add(CategoryFetch());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          const Header(title: "Kategorije"),

          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              bloc: categoryBloc,
              buildWhen:
                  (previous, current) =>
                      current is CategoryLoaded || current is CategoryLoading,
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ).copyWith(top: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: const Color(0xFFF5F5F5),
                    ),
                    child: ListView.builder(
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(category: state.categories[index]);
                      },
                    ),
                  );
                }

                return Loader();
              },
            ),
          ),
        ],
      ),
    );
  }
}
