import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/admin/widgets/order_card.dart';
import 'package:shopito_app/blocs/admin_orders/admin_orders_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  AdminOrdersBloc get _adminOrdersBloc => getIt<AdminOrdersBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
      bloc: _adminOrdersBloc,
      builder: (context, state) {
        if (state is AdminOrdersLoaded) {
          if (state.orders.isEmpty) {
            return const Center(child: Text('Nema narudžbi'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _adminOrdersBloc.add(AdminOrdersFetch(isRefresh: true));
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: state.orders[index]);
              },
            ),
          );
        }

        return const Loader();
      },
    );
  }
}
