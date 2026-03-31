import 'package:either_dart/either.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/data/models/order.dart';
import 'package:shopito_app/data/models/profile_failure.dart';
import 'package:shopito_app/data/models/register_failure.dart';
import 'package:shopito_app/data/models/auth_success.dart';
import 'package:shopito_app/data/models/user.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/network_service.dart';
import 'package:shopito_app/services/secure_storage_service.dart';

class AuthRepository {
  AuthRepository({
    required this.dioService,
    required this.secureStorageService,
    required this.logger,
    required this.networkService,
  });

  final DioService dioService;
  final SecureStorageService secureStorageService;
  final NetworkService networkService;
  final Logger logger;

  Future<Either<RegisterFailure, AuthSuccess>> register(User user) async {
    if (await networkService.isAppOnline()) {
      try {
        final response = await dioService.post(
          url: '/auth/signup',
          data: user.toJson(),
        );

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final user = User.fromJson(data['user']);
          final token = data['token'];

          //keep user id and tokens in secure storage
          secureStorageService.storeUserIdAndTokens(
            accessToken: token,
            userId: user.id.toString(),
          );

          return Right(AuthSuccess(user: user, token: token));
        } else {
          return Left(RegisterFailure(message: response.data['message']));
        }
      } catch (e) {
        logger.severe('Error registering user: $e');
        return Left(RegisterFailure(message: 'Error registering user'));
      }
    }
    return Left(RegisterFailure(message: 'No internet connection'));
  }

  Future<Either<RegisterFailure, AuthSuccess>> login(
    String email,
    String password,
  ) async {
    if (await networkService.isAppOnline()) {
      try {
        final response = await dioService.post(
          url: '/auth/signin',
          data: {'email': email, 'password': password},
        );

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final user = User.fromJson(data['user']);
          final token = data['token'];

          //keep user id and tokens in secure storage
          secureStorageService.storeUserIdAndTokens(
            accessToken: token,
            userId: user.id.toString(),
          );

          return Right(AuthSuccess(user: user, token: token));
        } else {
          return Left(RegisterFailure(message: response.data['message']));
        }
      } catch (e) {
        logger.severe('Error logging in: $e');
        return Left(RegisterFailure(message: 'Error logging in'));
      }
    }
    return Left(RegisterFailure(message: 'No internet connection'));
  }

  Future<bool> logout() async {
    if (await networkService.isAppOnline()) {
      try {
        await dioService.post(url: '/auth/signout');
        await secureStorageService.clearStorage();
        return true;
      } catch (e) {
        logger.severe('Error logging out: $e');
      }
    }
    return false;
  }

  Future<Either<RegisterFailure, AuthSuccess>> checkAuthStatus() async {
    if (await networkService.isAppOnline()) {
      try {
        final response = await dioService.get(url: '/auth/me');
        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final user = User.fromJson(data['user']);
          final token = await secureStorageService.getAccessToken();
          return Right(AuthSuccess(user: user, token: token ?? ''));
        } else {
          return Left(RegisterFailure(message: response.data['message']));
        }
      } catch (e) {
        logger.severe('Error checking auth status: $e');
        await secureStorageService.clearStorage();
        return Left(RegisterFailure(message: 'Error checking auth status'));
      }
    }

    return Left(RegisterFailure(message: 'No internet connection'));
  }

  Future<Either<ProfileFailure, User>> updateProfile(UserResponse user) async {
    if (await networkService.isAppOnline()) {
      try {
        final response = await dioService.put(
          url: '/users/${user.id}',
          data: user.toJson(),
        );

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final user = User.fromJson(data);
          return Right(user);
        }
      } catch (e) {
        logger.severe('Error updating profile: $e');
        return Left(ProfileFailure(message: 'Error updating profile'));
      }
    }

    return Left(ProfileFailure(message: 'No internet connection'));
  }
}
