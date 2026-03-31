import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/search/search_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';
import 'package:shopito_app/presentation/widgets/category/category_filters.dart';
import 'package:shopito_app/presentation/widgets/search/empty_state.dart';
import 'package:shopito_app/presentation/widgets/search/search_no_results.dart';
import 'package:shopito_app/presentation/widgets/search/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int selectedCategory = -1;
  String searchQuery = "";
  bool isSearching = false;
  final searchBloc = getIt<SearchBloc>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
        isSearching = searchQuery.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3C8D2F),
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          searchBloc.clearSearch();
                          context.pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            onChanged: (value) {
                              searchBloc.add(
                                SearchFetch(
                                  query: value,
                                  categoryId: selectedCategory,
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              hintText: "Pretraži proizvode...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              suffixIcon:
                                  _searchController.text.isNotEmpty
                                      ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          searchBloc.add(
                                            SearchFetch(
                                              query: '',
                                              categoryId: selectedCategory,
                                            ),
                                          );
                                          setState(() {
                                            searchQuery = '';
                                            isSearching = false;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.grey.shade600,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                      : null,
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
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: const Color(0xFFF5F5F5),
                ),
                child: Column(
                  children: [
                    CategoryFilters(
                      onCategorySelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                        searchBloc.add(
                          SearchFetch(
                            query: searchQuery,
                            categoryId: selectedCategory,
                          ),
                        );
                      },
                    ),
                    // Search results
                    Expanded(
                      child: BlocBuilder<SearchBloc, SearchState>(
                        bloc: searchBloc,
                        builder: (context, state) {
                          if (state is SearchLoaded) {
                            return state.products.isEmpty
                                ? EmptyState()
                                : _buildSearchResults(state.products);
                          }
                          if (state is SearchLoading) {
                            return Loader();
                          }
                          return EmptyState();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Product> products) {
    if (products.isEmpty) {
      return SearchNoResults();
    }

    return SearchResults(products: products);
  }
}
