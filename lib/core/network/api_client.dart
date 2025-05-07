import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/token_storage.dart';

class ApiClient {
  final String baseUrl;
  final Dio _dio;
  final TokenStorage _tokenStorage;
  bool _isRefreshing = false;

  ApiClient({
    required this.baseUrl,
    required TokenStorage tokenStorage,
    Dio? dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
    _dio.interceptors.add(_createAuthInterceptor());
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.extra['requireAuth'] == true) {
          final token = await _tokenStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401 &&
            !_isRefreshing &&
            error.requestOptions.extra['requireAuth'] == true) {
          _isRefreshing = true;
          try {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the request with the new token
              final token = await _tokenStorage.getAccessToken();
              final opts = Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );
              opts.headers?['Authorization'] = 'Bearer $token';

              // Create a new request with the updated token
              final response = await _dio.request(
                error.requestOptions.path,
                options: opts,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(response);
            }
          } finally {
            _isRefreshing = false;
          }
        }
        // Convert DioException to ApiException
        final apiException = _dioErrorToApiException(error);
        return handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: apiException,
            type: error.type,
            response: error.response,
            message: apiException.message,
          ),
        );
      },
    );
  }

  ApiException _dioErrorToApiException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return ApiException(
        message: 'Request timed out. Please try again.',
        statusCode: 0,
        errorCode: 'TIMEOUT_ERROR',
      );
    } else if (error.type == DioExceptionType.connectionError) {
      return ApiException(
        message: 'Unable to connect to the server. Please check your internet connection and try again.',
        statusCode: 0,
        errorCode: 'NETWORK_ERROR',
      );
    } else if (error.response != null) {
      try {
        final errorBody = error.response!.data;
        final errorCode = errorBody['error_code'];

        return ApiException(
          message: errorBody['message'] ?? 'Unknown error',
          errorCode: errorCode,
          statusCode: error.response!.statusCode ?? 0,
          details: errorBody['detail'],
          traceId: errorBody['trace_id'],
        );
      } catch (e) {
        return ApiException(
          message: 'Unable to process server response. Please try again later.',
          statusCode: error.response?.statusCode ?? 0,
          errorCode: 'PARSE_ERROR',
        );
      }
    } else {
      return ApiException(
        message: 'An unexpected error occurred. Please try again later.',
        statusCode: 0,
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        bool requireAuth = false,
      }) async {
    try {
      final options = Options(
        headers: headers,
        extra: {'requireAuth': requireAuth},
      );

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _dioErrorToApiException(e);
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        bool requireAuth = false,
      }) async {
    try {
      final options = Options(
        headers: headers,
        extra: {'requireAuth': requireAuth},
      );

      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _dioErrorToApiException(e);
    }
  }

  Future<Map<String, dynamic>> patch(
      String endpoint, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        bool requireAuth = false,
      }) async {
    try {
      final options = Options(
        headers: headers,
        extra: {'requireAuth': requireAuth},
      );
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _dioErrorToApiException(e);
    }
  }

  Map<String, dynamic> _processResponse(Response response) {
    if (response.data == null || (response.data is String && (response.data as String).isEmpty)) {
      return {'success': true};
    }

    if (response.data is Map<String, dynamic>) {
      return response.data;
    }

    try {
      if (response.data is String) {
        return json.decode(response.data);
      }
      return response.data;
    } catch (e) {
      throw ApiException(
        message: 'Unable to parse server response. Please try again later.',
        statusCode: response.statusCode ?? 0,
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final options = Options(
        headers: {'Content-Type': 'application/json'},
        extra: {'requireAuth': false},
      );

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: options,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _tokenStorage.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        return true;
      } else {
        // If refresh fails, clear tokens
        await _tokenStorage.clearTokens();
        return false;
      }
    } catch (e) {
      await _tokenStorage.clearTokens();
      return false;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final String? errorCode;
  final int statusCode;
  final dynamic details;
  final String? traceId;

  ApiException({
    required this.message,
    this.errorCode,
    required this.statusCode,
    this.details,
    this.traceId,
  });

  bool get isValidationError => errorCode == 'VALIDATION_ERROR';

  Map<String, String> extractValidationErrors() {
    final Map<String, String> fieldErrors = {};

    if (!isValidationError || details == null) {
      return fieldErrors;
    }

    try {
      if (details is List) {
        for (var error in details) {
          if (error is Map<String, dynamic>) {
            error.forEach((field, fieldDetail) {
              if (fieldDetail is Map<String, dynamic> &&
                  fieldDetail.containsKey('translation')) {
                fieldErrors[field] = fieldDetail['translation'];
              }
            });
          }
        }
      }
    } catch (e) {
      // If parsing fails, return empty map
    }

    return fieldErrors;
  }

  @override
  String toString() => 'ApiException: $message (Code: $errorCode)';
}
