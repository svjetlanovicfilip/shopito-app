import 'package:either_dart/either.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/data/models/cart_failure.dart';
import 'package:shopito_app/data/models/cart_item_request.dart';
import 'package:shopito_app/data/models/cart_response.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/network_service.dart';
import 'package:shopito_app/services/secure_storage_service.dart';

class CartRepository {
  final NetworkService networkService;
  final DioService dioService;
  final SecureStorageService secureStorageService;
  final Logger logger;

  CartRepository({
    required this.networkService,
    required this.dioService,
    required this.secureStorageService,
    required this.logger,
  });

  Future<Either<CartFailure, CartResponse>> getCart() async {
    if (!(await networkService.isAppOnline())) {
      return Left(CartFailure('No internet connection'));
    }

    try {
      final userId = await secureStorageService.getUserId();

      final response = await dioService.get(url: '/carts/user/$userId/details');

      if (response.statusCode == 200) {
        return Right(CartResponse.fromJson(response.data));
      }

      return Left(CartFailure('Failed to get cart'));
    } catch (e) {
      return Left(CartFailure(e.toString()));
    }
  }

  Future<Either<CartFailure, CartResponse>> addToCart(
    CartItemRequest cartItemRequest,
  ) async {
    if (!(await networkService.isAppOnline())) {
      return Left(CartFailure('No internet connection'));
    }

    try {
      final userId = await secureStorageService.getUserId();

      final response = await dioService.post(
        url: '/cart-items/user/$userId/add',
        data: cartItemRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(CartResponse.fromJson(response.data));
      }

      return Left(CartFailure('Failed to add to cart'));
    } catch (e) {
      return Left(CartFailure(e.toString()));
    }
  }

  Future<Either<CartFailure, CartResponse?>> updateCartItem(
    int cartItemId,
    int quantity,
  ) async {
    if (!(await networkService.isAppOnline())) {
      return Left(CartFailure('No internet connection'));
    }

    try {
      final response = await dioService.put(
        url: '/cart-items/$cartItemId/details',
        queryParameters: {'quantity': quantity},
      );

      if (response.statusCode == 200) {
        if (response.data.toString().isEmpty) {
          return Right(null);
        }

        return Right(CartResponse.fromJson(response.data));
      }

      return Left(CartFailure('Failed to update cart item'));
    } catch (e) {
      return Left(CartFailure(e.toString()));
    }
  }

  Future<Either<CartFailure, CartResponse?>> removeCartItem(
    int cartItemId,
  ) async {
    if (!(await networkService.isAppOnline())) {
      return Left(CartFailure('No internet connection'));
    }

    try {
      final response = await dioService.delete(
        url: '/cart-items/$cartItemId/details',
      );

      if (response.statusCode == 200) {
        if (response.data.toString().isEmpty) {
          return Right(null);
        }

        return Right(CartResponse.fromJson(response.data));
      }

      return Left(CartFailure('Failed to remove cart item'));
    } catch (e) {
      return Left(CartFailure(e.toString()));
    }
  }
}
