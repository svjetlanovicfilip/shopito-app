import 'package:flutter/material.dart';
import 'package:shopito_app/admin/widgets/order_menagament_header.dart';
import 'package:shopito_app/admin/widgets/orders_list.dart';
import 'package:shopito_app/blocs/admin_orders/admin_orders_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/order_status.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  final AdminOrdersBloc _adminOrdersBloc = getIt<AdminOrdersBloc>();

  OrderStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    _adminOrdersBloc.add(AdminOrdersFetch());
  }

  @override
  void dispose() {
    _adminOrdersBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF1976D2),
        toolbarHeight: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const OrderMenagamentHeader(),
            const SizedBox(height: 16),
            Expanded(child: OrdersList()),
          ],
        ),
      ),
    );
  }
}
