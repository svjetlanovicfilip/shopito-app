import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/order/order_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';
import 'package:shopito_app/presentation/widgets/order/order_list_item.dart';

class OrdersSection extends StatefulWidget {
  const OrdersSection({super.key});

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  final OrderBloc _orderBloc = getIt<OrderBloc>();

  @override
  void initState() {
    super.initState();
    _orderBloc.add(OrderGetUserOrders());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      bloc: _orderBloc,
      buildWhen:
          (previous, current) =>
              current is OrderUserOrdersLoaded ||
              current is OrderUserOrdersLoading,
      builder: (context, state) {
        if (state is OrderUserOrdersLoading) {
          return const Center(child: Loader());
        }
        if (state is OrderUserOrdersLoaded) {
          return Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Moje narudžbe",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121212),
                      ),
                    ),
                    Text(
                      "${state.orders.length} narudžbi",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...state.orders.map((order) => OrderListItem(order: order)),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
