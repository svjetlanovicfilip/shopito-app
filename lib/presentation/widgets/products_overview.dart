import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/product/product_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/L/products_list.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';
import 'package:shopito_app/presentation/widgets/error_widget.dart' as error;

class ProductsOverview extends StatelessWidget {
  const ProductsOverview({super.key});

  ProductBloc get _productBloc => getIt<ProductBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: _productBloc,
      builder: (context, state) {
        if (state is ProductLoaded) {
          return NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent * 0.85 &&
                  !_productBloc.areProductsLoaded) {
                _fetchProducts();
              }
              return false;
            },
            child: ProductsList(products: state.products),
          );
        } else if (state is ProductError) {
          return error.ErrorWidget(
            onPressed: _fetchProducts,
            message: state.message,
          );
        }

        return const Loader();
      },
    );
  }

  void _fetchProducts() {
    _productBloc.add(ProductFetch());
  }
}
