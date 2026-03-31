import 'package:either_dart/either.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/models/order_failure.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/network_service.dart';
import 'package:shopito_app/services/secure_storage_service.dart';

class OrderRepository {
  final DioService dioService;
  final NetworkService networkService;
  final Logger logger;
  final SecureStorageService secureStorageService;

  OrderRepository({
    required this.dioService,
    required this.networkService,
    required this.logger,
    required this.secureStorageService,
  });

  Future<Either<OrderFailure, OrderResponse>> createOrderPreview(
    OrderRequest order,
  ) async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    final userId = await secureStorageService.getUserId();

    try {
      final response = await dioService.post(
        url: '/orders',
        data: order.toJson(int.parse(userId ?? '0')),
      );

      if (response.statusCode == 200) {
        return Right(OrderResponse.fromJson(response.data));
      } else {
        return Left(OrderFailure(message: 'Failed to create order preview'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to create order preview'));
    }
  }

  Future<Either<OrderFailure, OrderResponse>> confirmOrder(int orderId) async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.post(url: '/orders/$orderId/confirm');

      if (response.statusCode == 200) {
        return Right(OrderResponse.fromJson(response.data));
      } else {
        return Left(OrderFailure(message: 'Failed to confirm order'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to confirm order'));
    }
  }

  Future<Either<OrderFailure, bool>> discardOrderPreview(int orderId) async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.patch(
        url: '/orders/$orderId/status',
        data: {'status': 'EXPIRED'},
      );

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(OrderFailure(message: 'Failed to discard order preview'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to discard order preview'));
    }
  }

  Future<Either<OrderFailure, List<OrderResponse>>> getUserOrders() async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    final userId = await secureStorageService.getUserId();

    try {
      final response = await dioService.get(url: '/orders/user/$userId');

      if (response.statusCode == 200) {
        return Right(
          List.from(
            response.data,
          ).map((e) => OrderResponse.fromJson(e)).toList(),
        );
      } else {
        return Left(OrderFailure(message: 'Failed to get user orders'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to get user orders'));
    }
  }

  Future<Either<OrderFailure, ({List<OrderResponse> orders, int total})>>
  getOrdersForAdmin({String? status, required int page}) async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(
        url: '/orders',
        queryParameters: {
          'status': status?.toUpperCase(),
          'page': page,
          'size': 24,
        },
      );

      if (response.statusCode == 200) {
        final content =
            List.from(
              response.data['content'],
            ).map((e) => OrderResponse.fromJson(e)).toList();
        final total = response.data['totalElements'] as int;

        return Right((orders: content, total: total));
      } else {
        return Left(OrderFailure(message: 'Failed to get orders for admin'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to get orders for admin'));
    }
  }

  Future<Either<OrderFailure, OrderResponse>> changeStatusByAdmin(
    int orderId,
    String status,
  ) async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.patch(
        url: '/orders/$orderId/status',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        return Right(OrderResponse.fromJson(response.data));
      } else {
        return Left(OrderFailure(message: 'Failed to discard order preview'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to discard order preview'));
    }
  }

  Future<Either<OrderFailure, bool>> markOrderAsDelivered(int orderId) async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.patch(
        url: '/orders/$orderId/delivered',
      );

      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(OrderFailure(message: 'Failed to mark order as delivered'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to mark order as delivered'));
    }
  }

  Future<Either<OrderFailure, OrderResponse>> getOrderById(int orderId) async {
    if (!(await networkService.isAppOnline())) {
      return Left(OrderFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(url: '/orders/$orderId');

      if (response.statusCode == 200) {
        return Right(OrderResponse.fromJson(response.data));
      } else {
        return Left(OrderFailure(message: 'Failed to get order details'));
      }
    } catch (e) {
      return Left(OrderFailure(message: 'Failed to get order details'));
    }
  }
}
