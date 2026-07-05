import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../error/failures.dart';
import '../storage/secure_storage.dart';

part 'dio_client.g.dart';

/// Build-time configuration. NEVER hardcode the backend URL, Supabase URL,
/// or Supabase key — all injected via `--dart-define` (API.md Section 1.1 /
/// CLAUDE.md Security Rules). `backendUrl` falls back to a local dev server
/// only when no --dart-define is supplied.
class Env {
  Env._();

  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:3000/v1',
  );
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_KEY');
}

/// The single Dio instance for the whole app.
@riverpod
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.backendUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(ErrorInterceptor());

  return dio;
}

/// Attaches the Supabase access token as a Bearer header on every request,
/// plus X-Shop-Id for shopkeeper requests (API.md Section 1.2).
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    final role = session?.user.userMetadata?['role'] as String?;
    if (role == 'shopkeeper') {
      final shopId = await SecureStorage.instance.read('shop_id');
      if (shopId != null) {
        options.headers['X-Shop-Id'] = shopId;
      }
    }

    handler.next(options);
  }
}

/// Converts every DioException into a Failure so repositories never deal
/// with raw HTTP/Dio errors.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: _toFailure(err)));
  }

  Failure _toFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(
          code: 'NETWORK_TIMEOUT',
          message: 'Connection timeout. Check your internet.',
        );
      default:
        break;
    }

    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final errorBody = data is Map ? data['error'] : null;
    final code = errorBody is Map ? errorBody['code'] as String? : null;
    final message = errorBody is Map ? errorBody['message'] as String? : null;

    if (statusCode == 401) {
      return AuthFailure(
        code: code ?? 'AUTH_TOKEN_INVALID',
        message: message ?? 'Session expired. Please log in again.',
      );
    }

    if (statusCode == 500) {
      return ServerFailure(
        code: code ?? 'INTERNAL_SERVER_ERROR',
        message: message ?? 'Something went wrong on our end. Please try again.',
      );
    }

    return UnknownFailure(
      code: code ?? 'UNKNOWN_ERROR',
      message: message ?? 'An unexpected error occurred.',
    );
  }
}
