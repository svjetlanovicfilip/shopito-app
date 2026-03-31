import 'package:either_dart/either.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/data/models/product_failure.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/network_service.dart';

class ProductRepository {
  ProductRepository({
    required this.dioService,
    required this.networkService,
    required this.logger,
  });

  final DioService dioService;
  final NetworkService networkService;
  final Logger logger;

  Future<Either<ProductException, ({List<Product> products, int total})>>
  getProducts({required int page, int size = 24}) async {
    if (!await networkService.isAppOnline()) {
      return Left(ProductNetworkException(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(
        url: '/products',
        queryParameters: {'page': page, 'size': size},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final products =
            (data['content'] as List)
                .map((json) => Product.fromJson(json))
                .toList();

        final total = data['totalElements'] as int;

        return Right((products: products, total: total));
      } else {
        logger.severe('Error fetching products: ${response.statusCode}');
        return Left(ProductClientException(message: 'Failed to load products'));
      }
    } catch (e) {
      logger.severe('Error fetching products: $e');
      return Left(
        ProductServerException(
          message: 'Something went wrong, please try again later',
        ),
      );
    }
  }

  Future<Either<ProductException, Product>> getProductById({
    required int id,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(ProductNetworkException(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(url: '/products/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final product = Product.fromJson(data);
        return Right(product);
      } else {
        return Left(ProductClientException(message: 'Failed to load product'));
      }
    } catch (e) {
      logger.severe('Error fetching product by id: $e');
      return Left(
        ProductServerException(
          message: 'Something went wrong, please try again later',
        ),
      );
    }
  }

  Future<Either<ProductException, ({List<Product> products, int total})>>
  getProductsByCategory({
    required int categoryId,
    int page = 0,
    int size = 24,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(ProductNetworkException(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(
        url: '/products/category/$categoryId',
        queryParameters: {'page': page, 'size': size},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final products =
            (data['content'] as List)
                .map((json) => Product.fromJson(json))
                .toList();

        final total = data['totalElements'] as int;

        return Right((products: products, total: total));
      } else {
        return Left(
          ProductClientException(
            message: 'Failed to load products for category',
          ),
        );
      }
    } catch (e) {
      logger.severe('Error fetching products by category: $e');
      return Left(
        ProductServerException(
          message: 'Something went wrong, please try again later',
        ),
      );
    }
  }

  Future<Either<ProductException, Product>> createProduct({
    required Product product,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(ProductNetworkException(message: 'No internet connection'));
    }

    try {
      final response = await dioService.post(
        url: '/products',
        data: product.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final product = Product.fromJson(data);
        return Right(product);
      } else {
        return Left(
          ProductClientException(message: 'Failed to create product'),
        );
      }
    } catch (e) {
      logger.severe('Error creating product: $e');
      return Left(
        ProductServerException(
          message: 'Something went wrong, please try again later',
        ),
      );
    }
  }

  Future<Either<ProductException, Product>> updateProduct({
    required Product product,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(ProductNetworkException(message: 'No internet connection'));
    }

    try {
      final response = await dioService.put(
        url: '/products/${product.id}',
        data: product.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final product = Product.fromJson(data);
        return Right(product);
      } else {
        return Left(
          ProductClientException(message: 'Failed to update product'),
        );
      }
    } catch (e) {
      logger.severe('Error updating product: $e');
      return Left(
        ProductServerException(
          message: 'Something went wrong, please try again later',
        ),
      );
    }
  }

  Future<Either<ProductException, bool>> deleteProduct({
    required int id,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(ProductNetworkException(message: 'No internet connection'));
    }

    try {
      final response = await dioService.delete(url: '/products/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else {
        return Left(
          ProductClientException(message: 'Failed to delete product'),
        );
      }
    } catch (e) {
      logger.severe('Error deleting product: $e');
      return Left(
        ProductServerException(
          message: 'Something went wrong, please try again later',
        ),
      );
    }
  }
}
