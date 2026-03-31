import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:shopito_app/main.dart';
import 'package:shopito_app/services/firebase_service.dart';
import 'package:shopito_app/services/secure_storage_service.dart';

class DioService {
  DioService({required this.secureStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    _setupInterceptors();
  }

  final SecureStorageService secureStorage;

  late Dio _dio;
  final _logger = Logger('DioService');

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ensure JSON Content-Type for POST/PUT requests
          if (options.method == 'POST' || options.method == 'PUT') {
            options.headers['Content-Type'] = 'application/json';
          }

          if (options.path.contains('/auth/signin') ||
              options.path.contains('/auth/signup')) {
            return handler.next(options);
          }

          final accessToken = await secureStorage.getAccessToken();
          options.headers['Authorization'] = 'Bearer $accessToken';

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        logPrint: (object) => _logger.info(object.toString()),
        requestBody: true,
      ),
    );
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;
    try {
      response = await _dio.get(url, queryParameters: queryParameters);
    } on DioException catch (e) {
      if (e.response != null) {
        response = e.response!;
        _logger
          ..warning('Response data: ${e.response?.data}')
          ..warning('Response headers: ${e.response?.headers}')
          ..warning('Request options: ${e.response?.requestOptions}');
      } else {
        _logger
          ..severe('Request failed: ${e.requestOptions}')
          ..severe('Error message: ${e.message}');
        response = Response(requestOptions: RequestOptions());
      }
    }

    return response;
  }

  Future<Response> post({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;
    try {
      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        response = e.response!;
        _logger
          ..warning('Response data: ${response.data}')
          ..warning('Response headers: ${response.headers}')
          ..warning('Request options: ${response.requestOptions}');
      } else {
        _logger
          ..severe('Request failed: ${e.requestOptions}')
          ..severe('Error message: ${e.message}');
        response = Response(requestOptions: RequestOptions());
      }
    }

    return response;
  }

  Future<Response> put({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;
    try {
      response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        response = e.response!;
        _logger
          ..warning('Response data: ${response.data}')
          ..warning('Response headers: ${response.headers}')
          ..warning('Request options: ${response.requestOptions}');
      } else {
        _logger
          ..severe('Request failed: ${e.requestOptions}')
          ..severe('Error message: ${e.message}');
        response = Response(requestOptions: RequestOptions());
      }
    }

    return response;
  }

  Future<Response> patch({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;
    try {
      response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        response = e.response!;
        _logger
          ..warning('Response data: ${response.data}')
          ..warning('Response headers: ${response.headers}')
          ..warning('Request options: ${response.requestOptions}');
      } else {
        _logger
          ..severe('Request failed: ${e.requestOptions}')
          ..severe('Error message: ${e.message}');
        response = Response(requestOptions: RequestOptions());
      }
    }

    return response;
  }

  Future<Response> delete({
    required String url,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;
    try {
      response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        response = e.response!;
        _logger
          ..warning('Response data: ${response.data}')
          ..warning('Response headers: ${response.headers}')
          ..warning('Request options: ${response.requestOptions}');
      } else {
        _logger
          ..severe('Request failed: ${e.requestOptions}')
          ..severe('Error message: ${e.message}');
        response = Response(requestOptions: RequestOptions());
      }
    }

    return response;
  }

  void registerLazySingleton(FirebaseService Function() param0) {}
}
