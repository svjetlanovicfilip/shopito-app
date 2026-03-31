import 'package:either_dart/either.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/data/models/category.dart';
import 'package:shopito_app/data/models/category_failure.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/network_service.dart';

class CategoryRepository {
  final NetworkService networkService;
  final DioService dioService;
  final Logger logger;

  CategoryRepository({
    required this.networkService,
    required this.dioService,
    required this.logger,
  });

  Future<Either<CategoryFailure, List<Category>>> getCategories() async {
    if (!await networkService.isAppOnline()) {
      return Left(CategoryFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(url: '/categories');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final categories = data.map((e) => Category.fromJson(e)).toList();
        return Right(categories);
      } else {
        return Left(CategoryFailure(message: 'Failed to load categories'));
      }
    } catch (e) {
      logger.severe('Error fetching categories: $e');
      return Left(CategoryFailure(message: 'Failed to load categories'));
    }
  }

  Future<Either<CategoryFailure, List<Category>>>
  getCategoriesWithProductCount() async {
    if (!await networkService.isAppOnline()) {
      return Left(CategoryFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(url: '/categories//with-count');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final categories = data.map((e) => Category.fromJson(e)).toList();
        return Right(categories);
      } else {
        return Left(CategoryFailure(message: 'Failed to load categories'));
      }
    } catch (e) {
      logger.severe('Error fetching categories: $e');
      return Left(CategoryFailure(message: 'Failed to load categories'));
    }
  }

  Future<Either<CategoryFailure, Category>> createCategory({
    required Category category,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(CategoryFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.post(
        url: '/categories',
        data: category.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return Right(Category.fromJson(data));
      } else {
        return Left(CategoryFailure(message: 'Failed to create category'));
      }
    } catch (e) {
      logger.severe('Error creating category: $e');
      return Left(CategoryFailure(message: 'Failed to create category'));
    }
  }

  Future<Either<CategoryFailure, Category>> updateCategory({
    required Category category,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(CategoryFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.put(
        url: '/categories/${category.id}',
        data: category.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return Right(Category.fromJson(data));
      } else {
        return Left(CategoryFailure(message: 'Failed to update category'));
      }
    } catch (e) {
      logger.severe('Error updating category: $e');
      return Left(CategoryFailure(message: 'Failed to update category'));
    }
  }

  Future<Either<CategoryFailure, bool>> deleteCategory({
    required int id,
  }) async {
    if (!await networkService.isAppOnline()) {
      return Left(CategoryFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.delete(url: '/categories/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else {
        return Left(CategoryFailure(message: 'Failed to delete category'));
      }
    } catch (e) {
      logger.severe('Error deleting category: $e');
      return Left(CategoryFailure(message: 'Failed to delete category'));
    }
  }
}
