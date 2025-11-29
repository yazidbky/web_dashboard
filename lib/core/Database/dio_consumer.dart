import 'package:dio/dio.dart';
import 'package:web_dashboard/core/Database/Local/local_storage.dart';
import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/Errors/exceptions.dart';
import 'package:web_dashboard/core/constants/base_url.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    dio.options = BaseOptions(
      baseUrl: BaseUrl.baseUrl,
      connectTimeout: const Duration(
        seconds: 90,
      ), // Increased for OAuth requests - 90 seconds
      sendTimeout: const Duration(
        seconds: 90,
      ), // Increased for OAuth requests - 90 seconds
      receiveTimeout: const Duration(
        seconds: 90,
      ), // Increased for OAuth requests - 90 seconds
      headers: {
        'Content-Type': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );

    // Add app origin interceptor

    // Add auth interceptor
    dio.interceptors.add(AuthInterceptor());

    // Add logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (object) => print(object),
      ),
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    print('=== DIO CONSUMER GET ===');
    print('Base URL: ${dio.options.baseUrl}');
    print('Full URL: ${dio.options.baseUrl}$path');

    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (error) {
      print('=== DIO CONSUMER GET ERROR ===');
      print('Status Code: ${error.response?.statusCode}');
      print('Response Data: ${error.response?.data}');
      print('Error: $error');
      handleDioException(error);
      rethrow;
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    print('=== DIO CONSUMER POST ===');
    print('Base URL: ${dio.options.baseUrl}');
    print('Full URL: ${dio.options.baseUrl}$path');
    print('Is Form Data: $isFormData');
    print('Request Data: $data');
    print('Data Type: ${data.runtimeType}');

    try {
      dynamic requestData = data;

      if (isFormData && data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
        print('Converted to FormData: $requestData');
      }

      final response = await dio.post(
        path,
        data: requestData,
        queryParameters: queryParameters,
        options: isFormData
            ? Options(contentType: 'multipart/form-data')
            : null,
      );
      print('=== DIO CONSUMER POST SUCCESS ===');
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      return response.data;
    } on DioException catch (error) {
      print('=== DIO CONSUMER POST ERROR ===');
      print('Status Code: ${error.response?.statusCode}');
      print('Response Data: ${error.response?.data}');
      print('Error: $error');
      handleDioException(error);
      rethrow;
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    print('=== DIO CONSUMER PUT ===');
    print('Base URL: ${dio.options.baseUrl}');
    print('Full URL: ${dio.options.baseUrl}$path');
    print('Is Form Data: $isFormData');
    print('Data: $data');

    try {
      dynamic requestData = data;

      if (isFormData && data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
        print('Converted to FormData: $requestData');
      }

      final response = await dio.put(
        path,
        data: requestData,
        queryParameters: queryParameters,
        options: isFormData
            ? Options(contentType: 'multipart/form-data')
            : null,
      );
      return response.data;
    } on DioException catch (error) {
      print('=== DIO CONSUMER PUT ERROR ===');
      print('Status Code: ${error.response?.statusCode}');
      print('Response Data: ${error.response?.data}');
      print('Error: $error');
      handleDioException(error);
      rethrow;
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (error) {
      handleDioException(error);
      rethrow;
    }
  }

  @override
  Future patch(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      dynamic requestData = data;

      if (isFormData && data is Map<String, dynamic>) {
        requestData = FormData.fromMap(data);
      }

      final response = await dio.patch(
        path,
        data: requestData,
        queryParameters: queryParameters,
        options: isFormData
            ? Options(contentType: 'multipart/form-data')
            : null,
      );
      return response.data;
    } on DioException catch (error) {
      handleDioException(error);
      rethrow;
    }
  }
}

// Add this Auth Interceptor class
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('=== AUTH INTERCEPTOR ===');
    print('Request URL: ${options.uri}');

    // Skip auth for login and signup endpoints
    final skipAuthPaths = [
      '/api/auth/login',
      '/api/auth/login/verify',
      '/api/auth/signup',
      '/api/auth/forgot-password',
      '/api/auth/oauth/login', // Skip auth for OAuth login
      '/api/auth/oauth/link', // Skip auth for OAuth link
    ];

    final shouldSkipAuth = skipAuthPaths.any(
      (path) => options.path.contains(path),
    );

    if (shouldSkipAuth) {
      print('⏭️ Skipping auth for: ${options.path}');
      handler.next(options);
      return;
    }

    // Get stored access token
    final accessToken = await LocalStorage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      print(
        '🔐 Added Authorization header: Bearer ${accessToken.substring(0, 20)}...',
      );
    } else {
      print('⚠️ No access token found for authenticated request');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('=== AUTH INTERCEPTOR ERROR ===');
    print('Error status: ${err.response?.statusCode}');
    print('Error path: ${err.requestOptions.path}');

    // Handle 401 errors (token expired)
    if (err.response?.statusCode == 401) {
      print('🔴 401 Unauthorized - Token expired or invalid');

      // Try to refresh token
      final refreshToken = await LocalStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        print('🔄 Attempting to refresh token...');

        try {
          // TODO: Implement token refresh API call
          // For now, just clear tokens and let user login again
          await _clearAuthTokensAndRedirect();
        } catch (e) {
          print('❌ Token refresh failed: $e');
          await _clearAuthTokensAndRedirect();
        }
      } else {
        print('❌ No refresh token available - clearing auth data');
        await _clearAuthTokensAndRedirect();
      }
    }

    handler.next(err);
  }

  Future<void> _clearAuthTokensAndRedirect() async {
    print('🧹 Clearing auth tokens due to authentication failure');
    await LocalStorage.clearAuthTokens();

    // TODO: Navigate to login screen
    // You might want to use a navigation service here
    print('🔄 User needs to login again');
  }
}
