import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../errors/failures.dart';

class NetworkService {
  late Dio _dio;
  String? _token;

  NetworkService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _clearToken();
        }
        handler.next(error);
      },
    ));
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    _token = token;
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    _token = null;
  }

  Future<Response> get(String path) async {
    await _loadToken();
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    await _loadToken();
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    await _loadToken();
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(String path) async {
    await _loadToken();
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> saveToken(String token) async {
    await _saveToken(token);
  }

  Future<void> clearToken() async {
    await _clearToken();
  }

  bool get isAuthenticated => _token != null;

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['error'] ?? 'Server error';
        if (statusCode == 401) {
          return const AuthFailure('Unauthorized');
        } else if (statusCode == 404) {
          return const ServerFailure('Resource not found');
        } else {
          return ServerFailure(message);
        }
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');
      default:
        return const NetworkFailure('Network error');
    }
  }
}
