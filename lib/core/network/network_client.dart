import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../constants/app_constants.dart';
import '../utils/failures.dart';

class NetworkClient {
  static final NetworkClient _instance = NetworkClient._internal();
  factory NetworkClient() => _instance;
  NetworkClient._internal();

  late final Dio _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('[REQUEST] ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('[ERROR] ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      if (fromJson != null) {
        return fromJson(response.data as Map<String, dynamic>);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      if (fromJson != null) {
        return fromJson(response.data as Map<String, dynamic>);
      }
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutFailure();
      case DioExceptionType.connectionError:
        return NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        if (statusCode == 400 || statusCode == 401) {
          return AuthFailure(
            e.response?.data?['message'] ?? 'Authentication failed',
          );
        }
        if (statusCode >= 500) {
          return ServerFailure('Server error ($statusCode)');
        }
        return ServerFailure('Request failed ($statusCode)');
      default:
        return UnknownFailure();
    }
  }
}
