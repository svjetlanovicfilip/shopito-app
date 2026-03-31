import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/cart_response.dart';
import 'package:shopito_app/presentation/widgets/cart/cart_content.dart';
import 'package:shopito_app/presentation/widgets/cart/empty_cart.dart';
import 'package:shopito_app/presentation/widgets/header.dart';

class CartDetailsScreen extends StatelessWidget {
  const CartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: "Korpa"),

        Expanded(
          child: BlocBuilder<CartBloc, CartState>(
            bloc: getIt<CartBloc>(),
            builder: (context, state) {
              if (state is CartLoaded) {
                if (state.cartResponse.items.isEmpty) {
                  return EmptyCart();
                }

                final cart = state.cartResponse;
                final originalTotal = _calculatePriceWithoutDiscount(cart);
                final hasDiscount = originalTotal != cart.total;

                return CartContent(
                  cartResponse: cart,
                  hasDiscount: hasDiscount,
                  originalTotal: originalTotal,
                );
              }

              return EmptyCart();
            },
          ),
        ),
      ],
    );
  }

  double _calculatePriceWithoutDiscount(CartResponse cart) {
    return cart.items.fold(
      0,
      (sum, item) =>
          sum +
          (item.product.priceWithoutDiscount ?? item.product.price) *
              item.quantity,
    );
  }
}
