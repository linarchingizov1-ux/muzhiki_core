import 'dart:io';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';

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

extension DioExceptionMapper on DioException {
  RequestError get requestError {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestError.timeout;

      case DioExceptionType.connectionError:
        final error = this.error;

        if (error is SocketException) {
          final message = error.message.toLowerCase();

          if (message.contains('failed host lookup') ||
              message.contains('name or service not known') ||
              message.contains('nodename nor servname provided')) {
            return RequestError.dns;
          }
        }

        return RequestError.connection;

      case DioExceptionType.cancel:
        return RequestError.cancelled;

      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;

        if (statusCode != null) {
          if (statusCode >= 400 && statusCode < 500) {
            return RequestError.http4xx;
          }

          if (statusCode >= 500) {
            return RequestError.http5xx;
          }
        }

        return RequestError.unknown;

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return RequestError.unknown;
    }
  }
}
