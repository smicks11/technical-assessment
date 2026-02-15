import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../constants/api_constants.dart';
import 'app_exceptions.dart';
import 'auth_storage_service.dart';

class ApiService {
  ApiService(this._dio, this._authStorage);

  final Dio _dio;
  final AuthStorageService _authStorage;
  static final Logger _log = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout:
            Duration(milliseconds: ApiConstants.connectTimeoutMs),
        sendTimeout: Duration(milliseconds: ApiConstants.sendTimeoutMs),
        receiveTimeout:
            Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        headers: {'Accept': 'application/json'},
      ),
    );
    return dio;
  }

  VoidCallback? _onUnauthorized;

  void setUnauthorizedCallback(VoidCallback? callback) {
    _onUnauthorized = callback;
  }

  void configureInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _logRequest(options);
          final token = await _authStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          return handler.next(response);
        },
        onError: (error, handler) async {
          _logError(error);
          if (error.response?.statusCode == 401) {
            final path = error.requestOptions.path;
            final isLoginRequest = path == ApiConstants.login ||
                path.endsWith(ApiConstants.login);
            if (!isLoginRequest) {
              await _authStorage.clearToken();
              _onUnauthorized?.call();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  void _logRequest(RequestOptions options) {
    _log.d('→ REQUEST');
    _log.d('  method: ${options.method}');
    _log.d('  uri: ${options.uri}');
    if (options.queryParameters.isNotEmpty) {
      _log.d('  queryParameters: ${options.queryParameters}');
    }
    final headers = Map<String, dynamic>.from(options.headers);
    if (headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer ***';
    }
    _log.d('  headers: $headers');
    if (options.data != null) {
      _log.d('  body: ${options.data}');
    }
  }

  void _logResponse(Response<dynamic> response) {
    _log.d('← RESPONSE');
    _log.d('  statusCode: ${response.statusCode}');
    _log.d('  uri: ${response.requestOptions.uri}');
    if (response.data != null) {
      _log.d('  body: ${response.data}');
    }
  }

  void _logError(DioException error) {
    _log.e(
      '← ERROR  uri: ${error.requestOptions.uri}  type: ${error.type}',
      error: error.message,
      stackTrace: error.stackTrace,
    );
    if (error.response != null) {
      _log.e('  statusCode: ${error.response?.statusCode}');
      if (error.response?.data != null) {
        _log.e('  body: ${error.response?.data}');
      }
    }
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      final data = response.data;
      if (data == null && response.statusCode == 204) return null;
      if (data == null) throw ServerException('Empty response');
      return data as T;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<T?> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      final responseData = response.data;
      if (responseData == null && response.statusCode == 204) return null;
      if (responseData == null) throw ServerException('Empty response');
      return responseData as T;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  AppException _mapDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = _extractMessage(e) ?? 'An error occurred';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(message);
      case DioExceptionType.cancel:
        return AppException('Request cancelled');
      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          return UnauthorizedException(message);
        }
        if (statusCode == 403) {
          return AppException('Access denied', 403);
        }
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ValidationException(message);
        }
        return ServerException(message, statusCode);
      default:
        return AppException(message, statusCode);
    }
  }

  String? _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      if (message != null && message.isNotEmpty) return message;
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first as String;
        if (first is String) return first;
      }
    }
    return e.message;
  }
}
