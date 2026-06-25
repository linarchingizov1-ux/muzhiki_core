import 'package:dio/dio.dart';

extension DioExceptionX on DioException {
  bool get isBackendError =>
      type == DioExceptionType.badResponse &&
      response != null &&
      response?.statusCode != null;

  bool get isNetworkError =>
      type == DioExceptionType.connectionError ||
      type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout ||
      type == DioExceptionType.badCertificate;

  bool get isAuthError {
    final code = response?.statusCode;
    return code == 401 || code == 419;
  }
}
