import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shopito_app/admin/admin_home_page.dart';
import 'package:shopito_app/admin/admin_order_details_screen.dart';
import 'package:shopito_app/config/router/scaffold_with_bottom_nav_bar.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/pages/cart_details_screen.dart';
import 'package:shopito_app/pages/cart_personal_info_screen.dart';
import 'package:shopito_app/pages/categories_page.dart';
import 'package:shopito_app/pages/category_products_screen.dart';
import 'package:shopito_app/pages/order_preview_screen.dart';
import 'package:shopito_app/pages/product_details_page.dart';
import 'package:shopito_app/pages/profile_page.dart';
import 'package:shopito_app/pages/search_page.dart';
import 'package:shopito_app/pages/splash_page.dart';
import 'package:shopito_app/pages/user_order_details_screen.dart';
import 'package:shopito_app/pages/login_screen.dart';
import 'package:shopito_app/pages/my_home_page.dart';
import 'package:shopito_app/pages/register_screen.dart';
import 'package:shopito_app/data/models/category.dart' as ctg;
import 'package:shopito_app/services/navigation_service.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String adminHome = '/adminHome';
  static const String cart = '/cart';
  static const String cartPersonalInfo = 'cartPersonalInfo';
  static const String orderPreview = 'orderPreview';
  static const String categories = '/categories';
  static const String categoryProducts = '/category-products';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String search = 'search';
  static const String productDetails = 'product-details';
  static const String orderDetails = 'order-details';
  static const String userOrderDetails = 'user-order-details';
}

final bottomBarRoutes = [
  Routes.home,
  Routes.categories,
  Routes.cart,
  Routes.profile,
];

final router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: Routes.root,
  onException: (context, _, __) => context.go(Routes.register),
  navigatorKey: NavigationService.instance.navigatorKey,
  routes: [
    GoRoute(
      path: Routes.root,
      name: Routes.root,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.register,
      name: Routes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, child) => ScaffoldWithBottomBarAndDrawer(
            navigationShell: child,
            shouldShowBottomBar: bottomBarRoutes.contains(state.uri.path),
          ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              name: Routes.home,
              builder: (context, state) => const MyHomePage(),
              routes: [
                GoRoute(
                  path: Routes.productDetails,
                  name: Routes.productDetails,
                  builder:
                      (context, state) =>
                          ProductDetailsPage(product: state.extra as Product),
                ),
                GoRoute(
                  path: Routes.search,
                  name: Routes.search,
                  builder: (context, state) => const SearchPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.categories,
              name: Routes.categories,
              builder: (context, state) => const CategoriesPage(),
            ),
            GoRoute(
              path: Routes.categoryProducts,
              name: Routes.categoryProducts,
              builder:
                  (context, state) => CategoryProductsScreen(
                    category: state.extra as ctg.Category,
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.cart,
              name: Routes.cart,
              builder: (context, state) => const CartDetailsScreen(),
              routes: [
                GoRoute(
                  path: Routes.cartPersonalInfo,
                  name: Routes.cartPersonalInfo,
                  builder: (context, state) => const CartPersonalInfoScreen(),
                ),
                GoRoute(
                  path: Routes.orderPreview,
                  name: Routes.orderPreview,
                  builder:
                      (context, state) => OrderPreviewScreen(
                        args: state.extra as OrderPreviewScreenArguments,
                      ),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              name: Routes.profile,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: '${Routes.userOrderDetails}/:id',
                  name: Routes.userOrderDetails,
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    final isAdmin = extra['isAdmin'] as bool? ?? false;
                    final isFromNotification =
                        extra['isFromNotification'] as bool? ?? false;

                    return UserOrderDetailsScreen(
                      orderId: int.parse(state.pathParameters['id']!),
                      isFromNotification: isFromNotification,
                      isAdmin: isAdmin,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: Routes.adminHome,
      name: Routes.adminHome,
      builder: (context, state) => const AdminHomePage(),
      routes: [
        GoRoute(
          path: Routes.orderDetails,
          name: Routes.orderDetails,
          builder:
              (context, state) =>
                  AdminOrderDetailsScreen(order: state.extra as OrderResponse),
        ),
      ],
    ),
  ],
);
