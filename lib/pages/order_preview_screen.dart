import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/blocs/order/order_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';

class OrderPreviewScreenArguments {
  OrderPreviewScreenArguments({
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
    required this.city,
    required this.address,
    required this.postalCode,
    required this.orderItems,
  });

  final String name;
  final String email;
  final String phone;
  final String country;
  final String city;
  final String address;
  final String postalCode;
  final List<OrderItem> orderItems;
}

class OrderPreviewScreen extends StatefulWidget {
  const OrderPreviewScreen({super.key, required this.args});

  final OrderPreviewScreenArguments args;

  @override
  State<OrderPreviewScreen> createState() => _OrderPreviewScreenState();
}

class _OrderPreviewScreenState extends State<OrderPreviewScreen>
    with TickerProviderStateMixin {
  final OrderBloc orderBloc = getIt<OrderBloc>();

  final _globalKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    orderBloc.add(
      OrderPreviewCreate(
        OrderRequest(
          status: 'PREVIEW',
          postalCode: widget.args.postalCode,
          countryName: widget.args.country,
          cityName: widget.args.city,
          addressName: widget.args.address,
          orderItems: widget.args.orderItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      bloc: orderBloc,
      listener: (context, state) {
        if (state is OrderConfirmationInProgress) {
          showOverlay();
        } else if (state is OrderConfirmationSuccess) {
          getIt<CartBloc>().add(CartClear());
          _removeOverlay();
          context.go(Routes.cart);
        } else if (state is OrderConfirmationFailed) {
          _removeOverlay();
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: _globalKey,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: const Color(0xFF3C8D2F),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showExitConfirmationDialog();
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        Text(
                          "Potvrda narudžbe",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<OrderBloc, OrderState>(
                      bloc: orderBloc,
                      buildWhen:
                          (previous, current) =>
                              current is OrderPreviewCreationSuccess ||
                              current is OrderPreviewCreationInProgress ||
                              current is OrderPreviewCreationFailed,
                      builder: (context, state) {
                        if (state is OrderPreviewCreationInProgress) {
                          return const Loader();
                        }

                        if (state is OrderPreviewCreationSuccess) {
                          return Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: const Color(0xFFF5F5F5),
                                  ),
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Order summary
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Sažetak narudžbe",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF121212),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    state
                                                        .orderResponse
                                                        .orderItems
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 8,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "${state.orderResponse.orderItems[index].quantity}x ${state.orderResponse.orderItems[index].product.name}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${(state.orderResponse.orderItems[index].price * state.orderResponse.orderItems[index].quantity).toStringAsFixed(2)} RSD",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                              0xFF3C8D2F,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              Divider(height: 20),
                                              _buildSummaryRow(
                                                "Ukupno bez dostave",
                                                "${state.orderResponse.subtotal.toStringAsFixed(2)} RSD",
                                              ),
                                              _buildSummaryRow(
                                                "Dostava",
                                                '${state.orderResponse.deliveryCost.toStringAsFixed(2)} RSD',
                                              ),
                                              const SizedBox(height: 8),
                                              _buildSummaryRow(
                                                "Ukupno",
                                                "${state.orderResponse.total.toStringAsFixed(2)} RSD",
                                                isTotal: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // Delivery info
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Podaci za dostavu",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF121212),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              _buildInfoRow(
                                                Icons.person,
                                                state
                                                    .orderResponse
                                                    .user
                                                    .fullname,
                                              ),
                                              _buildInfoRow(
                                                Icons.email,
                                                state.orderResponse.user.email,
                                              ),
                                              _buildInfoRow(
                                                Icons.phone,
                                                state
                                                    .orderResponse
                                                    .user
                                                    .phoneNumber,
                                              ),
                                              _buildInfoRow(
                                                Icons.flag,
                                                state
                                                    .orderResponse
                                                    .address
                                                    .countryName,
                                              ),
                                              _buildInfoRow(
                                                Icons.location_city,
                                                state
                                                    .orderResponse
                                                    .address
                                                    .cityName,
                                              ),
                                              _buildInfoRow(
                                                Icons.location_on,
                                                state
                                                    .orderResponse
                                                    .address
                                                    .addressName,
                                              ),
                                              _buildInfoRow(
                                                Icons.markunread_mailbox,
                                                state.orderResponse.postalCode,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // Payment method
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Način plaćanja",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF121212),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                    0xFF3C8D2F,
                                                  ).withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Color(
                                                      0xFF3C8D2F,
                                                    ).withValues(alpha: 0.3),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.money,
                                                      color: Color(0xFF3C8D2F),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Plaćanje pouzećem",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                0xFF121212,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Plaćate kada primate narudžbu",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors
                                                                      .grey
                                                                      .shade600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.check_circle,
                                                      color: Color(0xFF3C8D2F),
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 120,
                                        ), // Space for button
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      orderBloc.add(
                                        OrderConfirm(
                                          orderBloc.orderPreview!.id,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF3C8D2F),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      "Nastavi",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: Color(0xFF121212),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Color(0xFF3C8D2F) : Color(0xFF121212),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Color(0xFF121212)),
            ),
          ),
        ],
      ),
    );
  }

  void showOverlay() {
    // Ukloni postojeći overlay ako postoji
    _removeOverlay();

    final ctx = _globalKey.currentContext ?? context;
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {}, // Empty callback to prevent interaction
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Loader(),
      ),
    );
    _overlayEntry = OverlayEntry(builder: (context) => child);
    Overlay.of(ctx).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Napuštanje stranice'),
          content: const Text(
            'Jeste li sigurni da želite napustiti stranicu? Vaša narudžba neće biti sačuvana.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Zatvorit dijalog
              },
              child: const Text('Otkaži', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Zatvorit dijalog
                // Discard order i idi nazad
                if (orderBloc.orderPreview != null) {
                  orderBloc.add(
                    OrderPreviewDiscard(orderBloc.orderPreview!.id),
                  );
                }
                context.pop();
              },
              child: const Text(
                'Da, napusti',
                style: TextStyle(
                  color: Color(0xFF3C8D2F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
