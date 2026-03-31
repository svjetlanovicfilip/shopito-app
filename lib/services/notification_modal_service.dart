import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/blocs/auth/auth_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/config/router/router.dart';
import 'package:shopito_app/services/navigation_service.dart';

class NotificationModalService {
  static final Logger _logger = Logger('NotificationModalService');

  /// Handles foreground notifications by showing a bottom sheet
  static Future<void> handleForegroundNotification(
    BuildContext outerContext,
    RemoteMessage message,
  ) async {
    try {
      final orderId = _extractOrderId(message);
      if (orderId == null) {
        _logger.warning('No order_id found in notification data');
        return;
      }

      _logger.info('Showing order details modal for order: $orderId');

      await showModalBottomSheet(
        context: outerContext,
        backgroundColor: Colors.transparent,
        isScrollControlled: false,
        builder: (sheetContext) {
          return OrderNotificationBottomSheet(
            title: message.notification?.title ?? 'Nova obavijest',
            description:
                message.notification?.body ?? 'Pogledaj detalje narudžbe.',
            onOpen: () {
              final userRole = getIt<AuthBloc>().currentUser?.role;
              Navigator.of(sheetContext).pop();
              outerContext.pushNamed(
                Routes.userOrderDetails,
                pathParameters: {'id': orderId.toString()},
                extra: {
                  'isAdmin': userRole == 'ADMIN',
                  'isFromNotification': true,
                },
              );
            },
          );
        },
      );
    } catch (e) {
      _logger.severe('Error handling foreground notification: $e');
      rethrow;
    }
  }

  /// Handles background/terminated app notifications
  static Future<void> handleBackgroundNotification(
    RemoteMessage message,
  ) async {
    try {
      final orderId = _extractOrderId(message);
      if (orderId == null) {
        _logger.warning('No order_id found in notification data');
        return;
      }

      _logger.info('Handling background notification for order: $orderId');

      // Wait for the app to be ready
      await _waitForAppReady();

      final ctx = NavigationService.instance.currentContext;
      if (ctx != null && ctx.mounted) {
        await showModalBottomSheet(
          context: ctx,
          backgroundColor: Colors.transparent,
          isScrollControlled: false,
          builder: (sheetContext) {
            return OrderNotificationBottomSheet(
              title: message.notification?.title ?? 'Nova obavijest',
              description:
                  message.notification?.body ?? 'Pogledaj detalje narudžbe.',
              onOpen: () {
                Navigator.of(sheetContext).pop();
                final userRole = getIt<AuthBloc>().currentUser?.role;
                ctx.pushNamed(
                  Routes.userOrderDetails,
                  pathParameters: {'id': orderId.toString()},
                  extra: {
                    'isAdmin': userRole == 'ADMIN',
                    'isFromNotification': true,
                  },
                );
              },
            );
          },
        );
      } else {
        _logger.warning('No valid context available for showing modal');
      }
    } catch (e) {
      _logger.severe('Error handling background notification: $e');
    }
  }

  /// Extracts order ID from notification message
  static int? _extractOrderId(RemoteMessage message) {
    final orderIdString = message.data['order_id']?.toString();
    if (orderIdString != null) {
      return int.tryParse(orderIdString);
    }
    return null;
  }

  /// Waits for the app to be ready (context available)
  static Future<void> _waitForAppReady() async {
    int attempts = 0;
    const maxAttempts = 50; // 5 seconds total
    const delay = Duration(milliseconds: 100);

    while (attempts < maxAttempts) {
      if (NavigationService.instance.currentContext != null) {
        return;
      }
      await Future.delayed(delay);
      attempts++;
    }

    throw Exception('App context not available after waiting');
  }
}

class OrderNotificationBottomSheet extends StatelessWidget {
  const OrderNotificationBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.onOpen,
  });

  final String title;
  final String description;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onOpen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C8D2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Pogledaj narudžbu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// /// Bottom sheet widget that displays order details
// class OrderDetailsBottomSheet extends StatefulWidget {
//   const OrderDetailsBottomSheet({super.key, required this.orderId});

//   final int orderId;

//   @override
//   State<OrderDetailsBottomSheet> createState() =>
//       _OrderDetailsBottomSheetState();
// }

// class _OrderDetailsBottomSheetState extends State<OrderDetailsBottomSheet> {
//   OrderResponse? order;
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     _loadOrderDetails();
//   }

//   Future<void> _loadOrderDetails() async {
//     try {
//       setState(() {
//         isLoading = true;
//         error = null;
//       });

//       final orderRepository = getIt<OrderRepository>();

//       // Get order by ID directly
//       final result = await orderRepository.getOrderById(widget.orderId);

//       result.fold(
//         (failure) {
//           setState(() {
//             error = failure.message;
//             isLoading = false;
//           });
//         },
//         (foundOrder) {
//           setState(() {
//             order = foundOrder;
//             isLoading = false;
//           });
//         },
//       );
//     } catch (e) {
//       setState(() {
//         error = 'Greška pri učitavanju narudžbe: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.9,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Content
//           Expanded(child: _buildContent()),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     if (isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3C8D2F)),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Učitavanje narudžbe...',
//               style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       );
//     }

//     if (error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
//             SizedBox(height: 16),
//             Text(
//               error!,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _loadOrderDetails,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF3C8D2F),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text('Pokušaj ponovo'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (order == null) {
//       return Center(
//         child: Text(
//           'Narudžba nije pronađena',
//           style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//         ),
//       );
//     }

//     // Show the order details screen inside the bottom sheet
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//       child: UserOrderDetailsScreen(order: order!),
//     );
//   }
// }
