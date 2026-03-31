import 'package:either_dart/either.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/data/models/product.dart';
import 'package:shopito_app/data/models/search_failure.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/network_service.dart';

class SearchRepository {
  final NetworkService networkService;
  final DioService dioService;
  final Logger logger;

  SearchRepository({
    required this.networkService,
    required this.dioService,
    required this.logger,
  });

  Future<Either<SearchFailure, ({List<Product> products, int total})>>
  searchProducts({
    required String query,
    required int page,
    required int size,
    required int categoryId,
  }) async {
    if (!(await networkService.isAppOnline())) {
      return Left(SearchFailure('No internet connection'));
    }

    try {
      final response = await dioService.get(
        url: '/products/category/search',
        queryParameters: {
          'name': query,
          'page': page,
          'size': size,
          'categoryId': categoryId == -1 ? null : categoryId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final products =
            (data['content'] as List)
                .map((json) => Product.fromJson(json))
                .toList();

        final total = data['totalElements'] as int;

        return Right((products: products, total: total));
      }

      return Left(SearchFailure('Failed to search products'));
    } catch (e) {
      return Left(SearchFailure(e.toString()));
    }
  }
}
