import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/blocs/order/order_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/presentation/widgets/XS/cart_icon.dart';
import 'package:shopito_app/services/firebase_service.dart';

class ScaffoldWithBottomBarAndDrawer extends StatefulWidget {
  const ScaffoldWithBottomBarAndDrawer({
    required this.navigationShell,
    this.shouldShowBottomBar = true,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final bool shouldShowBottomBar;

  @override
  State<ScaffoldWithBottomBarAndDrawer> createState() =>
      _ScaffoldWithBottomBarAndDrawerState();
}

class _ScaffoldWithBottomBarAndDrawerState
    extends State<ScaffoldWithBottomBarAndDrawer> {
  @override
  void initState() {
    super.initState();
    getIt<CartBloc>().add(CartGetItems());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getIt<FirebaseService>().setupFirebaseMessaging();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      bloc: getIt<OrderBloc>(),
      listener: (context, state) {
        if (state is OrderConfirmationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Porudžbina je uspešno kreirana!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ID: ${state.orderResponse.id} • Ukupno: ${state.orderResponse.total.toStringAsFixed(2)} RSD',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // backgroundColor: Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(16),
              duration: Duration(seconds: 4),
            ),
          );
        } else if (state is OrderConfirmationFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Greška pri kreiranju porudžbine',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          state.error,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: Color(0xFFE53E3E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.all(16),
              duration: Duration(seconds: 5),
            ),
          );
        }
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFF3C8D2F),
          elevation: 0,
          toolbarHeight: 0,
        ),
        bottomNavigationBar:
            widget.shouldShowBottomBar
                ? BottomNavBar(
                  currentIndex: widget.navigationShell.currentIndex,
                  onTap: _onBottomNavTapped,
                )
                : null,
        body: SafeArea(child: widget.navigationShell),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Color(0xFF3C8D2F),
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Početna",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: "Kategorije",
          ),
          BottomNavigationBarItem(
            icon: CartIcon(),
            activeIcon: Icon(Icons.shopping_cart),
            label: "Korpa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
