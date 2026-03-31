import 'package:either_dart/either.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/data/models/user.dart';
import 'package:shopito_app/data/models/users_failure.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/network_service.dart';

class UsersRepository {
  final DioService dioService;
  final NetworkService networkService;
  final Logger logger;

  UsersRepository({
    required this.dioService,
    required this.networkService,
    required this.logger,
  });

  Future<Either<UsersFailure, List<User>>> getUsers() async {
    if (!(await networkService.isAppOnline())) {
      return Left(UsersFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.get(url: '/users');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        final users = data.map((e) => User.fromJsonAdmin(e)).toList();
        return Right(users);
      }
    } catch (e) {
      logger.severe('Error getting users: $e');
    }

    return Left(UsersFailure(message: 'Error getting users'));
  }

  Future<Either<UsersFailure, User>> changeUserRole(
    String userId,
    String roleName,
  ) async {
    if (!(await networkService.isAppOnline())) {
      return Left(UsersFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.patch(
        url: '/users/$userId/role',
        data: {'roleName': roleName},
      );

      if (response.statusCode == 200) {
        return Right(User.fromJsonAdmin(response.data));
      }
    } catch (e) {
      logger.severe('Error changing user role: $e');
    }

    return Left(UsersFailure(message: 'Error changing user role'));
  }

  Future<Either<UsersFailure, bool>> deleteUser(String userId) async {
    if (!(await networkService.isAppOnline())) {
      return Left(UsersFailure(message: 'No internet connection'));
    }

    try {
      final response = await dioService.delete(url: '/users/$userId');
      if (response.statusCode == 200) {
        return const Right(true);
      }
    } catch (e) {
      logger.severe('Error deleting user: $e');
    }

    return Left(UsersFailure(message: 'Error deleting user'));
  }
}
