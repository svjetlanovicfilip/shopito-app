import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      bloc: getIt<CartBloc>(),
      buildWhen:
          (previous, current) =>
              current is CartLoaded || current is CartCleared,
      builder: (context, state) {
        if (state is CartLoaded && state.cartResponse.totalItems > 0) {
          return Badge(
            label: Text(state.cartResponse.totalItems.toString()),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            child: Icon(Icons.shopping_cart_outlined),
          );
        }

        return Icon(Icons.shopping_cart_outlined, color: color);
      },
    );
  }
}
