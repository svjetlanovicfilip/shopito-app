import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/blocs/admin_orders/admin_orders_bloc.dart';
import 'package:shopito_app/blocs/auth/auth_bloc.dart';
import 'package:shopito_app/blocs/cart/cart_bloc.dart';
import 'package:shopito_app/blocs/category/category_bloc.dart';
import 'package:shopito_app/blocs/login/login_bloc.dart';
import 'package:shopito_app/blocs/order/order_bloc.dart';
import 'package:shopito_app/blocs/product/product_bloc.dart';
import 'package:shopito_app/blocs/register/register_bloc.dart';
import 'package:shopito_app/blocs/search/search_bloc.dart';
import 'package:shopito_app/blocs/users/users_bloc.dart';
import 'package:shopito_app/data/repository/auth_repository.dart';
import 'package:shopito_app/data/repository/cart_repository.dart';
import 'package:shopito_app/data/repository/category_repository.dart';
import 'package:shopito_app/data/repository/order_repository.dart';
import 'package:shopito_app/data/repository/product_repository.dart';
import 'package:shopito_app/data/repository/search_repository.dart';
import 'package:shopito_app/data/repository/users_repository.dart';
import 'package:shopito_app/services/auth_validator_service.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/firebase_service.dart';
import 'package:shopito_app/services/navigation_service.dart';
import 'package:shopito_app/services/network_service.dart';
import 'package:shopito_app/services/secure_storage_service.dart';

final getIt = GetIt.instance;

void initDeps() {
  // Services first (no dependencies)
  getIt
    ..registerSingleton<NavigationService>(NavigationService.instance)
    ..registerSingleton<SecureStorageService>(
      SecureStorageService(secureStorage: FlutterSecureStorage()),
    )
    ..registerLazySingleton<NetworkService>(() => NetworkService())
    ..registerFactory<AuthValidatorService>(() => AuthValidatorService());

  // Services with dependencies on other services
  getIt
    ..registerSingleton<DioService>(
      DioService(secureStorage: getIt<SecureStorageService>()),
    )
    ..registerLazySingleton<FirebaseService>(
      () => FirebaseService(
        dioService: getIt<DioService>(),
        logger: Logger('FirebaseService'),
        secureStorage: getIt<SecureStorageService>(),
      ),
    );

  // Repositories (depend on services)
  getIt
    ..registerSingleton<AuthRepository>(
      AuthRepository(
        networkService: getIt<NetworkService>(),
        dioService: getIt<DioService>(),
        secureStorageService: getIt<SecureStorageService>(),
        logger: Logger('AuthRepository'),
      ),
    )
    ..registerSingleton<ProductRepository>(
      ProductRepository(
        networkService: getIt<NetworkService>(),
        dioService: getIt<DioService>(),
        logger: Logger('ProductRepository'),
      ),
    )
    ..registerSingleton<CategoryRepository>(
      CategoryRepository(
        networkService: getIt<NetworkService>(),
        dioService: getIt<DioService>(),
        logger: Logger('CategoryRepository'),
      ),
    )
    ..registerSingleton<SearchRepository>(
      SearchRepository(
        networkService: getIt<NetworkService>(),
        dioService: getIt<DioService>(),
        logger: Logger('SearchRepository'),
      ),
    )
    ..registerSingleton<CartRepository>(
      CartRepository(
        networkService: getIt<NetworkService>(),
        dioService: getIt<DioService>(),
        secureStorageService: getIt<SecureStorageService>(),
        logger: Logger('CartRepository'),
      ),
    )
    ..registerSingleton<OrderRepository>(
      OrderRepository(
        networkService: getIt<NetworkService>(),
        dioService: getIt<DioService>(),
        secureStorageService: getIt<SecureStorageService>(),
        logger: Logger('OrderRepository'),
      ),
    )
    ..registerSingleton<UsersRepository>(
      UsersRepository(
        dioService: getIt<DioService>(),
        networkService: getIt<NetworkService>(),
        logger: Logger('UsersRepository'),
      ),
    );

  // Blocs (depend on repositories and services)
  getIt
    ..registerFactory<LoginBloc>(
      () => LoginBloc(
        authRepository: getIt<AuthRepository>(),
        authValidatorService: getIt<AuthValidatorService>(),
      ),
    )
    ..registerFactory<RegisterBloc>(
      () => RegisterBloc(
        authRepository: getIt<AuthRepository>(),
        authValidatorService: getIt<AuthValidatorService>(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(authRepository: getIt<AuthRepository>()),
    )
    ..registerLazySingleton(
      () => ProductBloc(productRepository: getIt<ProductRepository>()),
    )
    ..registerLazySingleton(
      () => CategoryBloc(
        categoryRepository: getIt<CategoryRepository>(),
        productRepository: getIt<ProductRepository>(),
      ),
    )
    ..registerLazySingleton(
      () => SearchBloc(searchRepository: getIt<SearchRepository>()),
    )
    ..registerLazySingleton(
      () => CartBloc(cartRepository: getIt<CartRepository>()),
    )
    ..registerLazySingleton(
      () => OrderBloc(orderRepository: getIt<OrderRepository>()),
    )
    ..registerLazySingleton(
      () => AdminOrdersBloc(orderRepository: getIt<OrderRepository>()),
    )
    ..registerLazySingleton(
      () => UsersBloc(usersRepository: getIt<UsersRepository>()),
    );
}
