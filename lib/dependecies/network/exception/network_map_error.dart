import 'dart:io';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_exception.dart';

class NetworkMapErrorApp {
  static NetworkExceptionApp map(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final error = e.error;

    if (error is NetworkExceptionApp) {
      return error;
    }

    final errorText = error?.toString().toLowerCase() ?? '';
    final messageText = e.message?.toLowerCase() ?? '';
    final combinedText = '$errorText $messageText';

    if (_isNoInternet(error, combinedText)) {
      return NetworkExceptionApp(
        message: 'Нет подключения к интернету. Проверьте соединение.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (_isConnectionInterrupted(error, combinedText)) {
      return NetworkExceptionApp(
        message: 'Соединение было прервано. Попробуйте ещё раз.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (_isTlsOrCertificateError(error, combinedText)) {
      return NetworkExceptionApp(
        message: 'Ошибка безопасного соединения.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.badResponse) {
      return NetworkExceptionApp(
        message: _mapStatusCode(statusCode, data),
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return NetworkExceptionApp(
        message: 'Превышено время ожидания подключения.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.sendTimeout) {
      return NetworkExceptionApp(
        message: 'Превышено время отправки данных.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return NetworkExceptionApp(
        message: 'Сервер слишком долго отвечает.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.badCertificate) {
      return NetworkExceptionApp(
        message: 'Ошибка сертификата безопасности.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.cancel) {
      return NetworkExceptionApp(
        message: 'Запрос был отменён.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return NetworkExceptionApp(
        message: 'Ошибка интернет-соединения. Проверьте интернет.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.unknown) {
      final backendMessage = _extractBackendMessage(data);
      if (backendMessage != null) {
        return NetworkExceptionApp(
          message: backendMessage,
          statusCode: statusCode,
          originalError: e,
        );
      }

      return NetworkExceptionApp(
        message: 'Неизвестная ошибка сети. Попробуйте позже.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    return NetworkExceptionApp(
      message: 'Не удалось выполнить запрос. Попробуйте позже.',
      statusCode: statusCode,
      originalError: e,
    );
  }

  static bool _isNoInternet(Object? error, String text) {
    if (error is SocketException) {
      final socketText = error.toString().toLowerCase();

      if (socketText.contains('failed host lookup') ||
          socketText.contains('network is unreachable') ||
          socketText.contains('no address associated with hostname') ||
          socketText.contains('nodename nor servname provided') ||
          socketText.contains('temporary failure in name resolution')) {
        return true;
      }
    }

    return text.contains('failed host lookup') ||
        text.contains('network is unreachable') ||
        text.contains('no address associated with hostname') ||
        text.contains('nodename nor servname provided') ||
        text.contains('temporary failure in name resolution');
  }

  static bool _isConnectionInterrupted(Object? error, String text) {
    if (error is SocketException) {
      final socketText = error.toString().toLowerCase();
      if (_containsInterruptedConnectionText(socketText)) {
        return true;
      }
    }

    if (error is HttpException) {
      final httpText = error.message.toLowerCase();
      if (_containsInterruptedConnectionText(httpText)) {
        return true;
      }
    }

    return _containsInterruptedConnectionText(text);
  }

  static bool _containsInterruptedConnectionText(String text) {
    return text.contains('connection reset by peer') ||
        text.contains('broken pipe') ||
        text.contains('connection aborted') ||
        text.contains('software caused connection abort') ||
        text.contains('connection closed') ||
        text.contains('connection terminated') ||
        text.contains('connection closed before full header was received') ||
        text.contains('connection reset') ||
        text.contains('bad file descriptor');
  }

  static bool _isTlsOrCertificateError(Object? error, String text) {
    if (error is HandshakeException) {
      return true;
    }

    return text.contains('certificate') ||
        text.contains('handshake') ||
        text.contains('ssl') ||
        text.contains('tls') ||
        text.contains('certificateverifyfailed');
  }

  static String _mapStatusCode(int? code, dynamic data) {
    final backendMessage = _extractBackendMessage(data);

    switch (code) {
      case 400:
        return backendMessage ?? 'Некорректный запрос.';
      case 401:
        return backendMessage ?? 'Необходима повторная авторизация.';
      case 403:
        return backendMessage ?? 'Доступ запрещён.';
      case 404:
        return backendMessage ?? 'Данные не найдены.';
      case 405:
        return backendMessage ?? 'Метод запроса не поддерживается.';
      case 408:
        return backendMessage ?? 'Время ожидания запроса истекло.';
      case 409:
        return backendMessage ?? 'Конфликт данных.';
      case 410:
        return backendMessage ?? 'Данные больше недоступны.';
      case 413:
        return 'Размер файла слишком большой.';
      case 415:
        return backendMessage ?? 'Неподдерживаемый формат данных.';
      case 419:
        return backendMessage ?? 'Сессия истекла.';
      case 422:
        return backendMessage ?? 'Ошибка проверки данных.';
      case 423:
        return backendMessage ?? 'Ресурс временно заблокирован.';
      case 429:
        return backendMessage ?? 'Слишком много запросов. Попробуйте позже.';
      case 500:
        return backendMessage ?? 'Внутренняя ошибка сервера.';
      case 501:
        return backendMessage ?? 'Функция не поддерживается сервером.';
      case 502:
      case 503:
      case 504:
        return backendMessage ?? 'Сервер временно недоступен.';
      default:
        return backendMessage ??
            'Ошибка сервера${code != null ? ': $code' : ''}.';
    }
  }

  static String? _extractBackendMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      for (final key in [
        'message',
        'error',
        'detail',
        'description',
        'errors',
        'title',
      ]) {
        final value = map[key];

        if (value is String && value.trim().isNotEmpty) {
          return value;
        }

        if (value is List && value.isNotEmpty) {
          return value.map((e) => e.toString()).join(', ');
        }

        if (value is Map && value.isNotEmpty) {
          final parts = <String>[];

          value.forEach((k, v) {
            if (v is List) {
              parts.addAll(v.map((e) => e.toString()));
            } else if (v != null) {
              parts.add(v.toString());
            }
          });

          if (parts.isNotEmpty) {
            return parts.join(', ');
          }
        }
      }
    }

    if (data is List && data.isNotEmpty) {
      return data.map((e) => e.toString()).join(', ');
    }

    if (data is String && data.trim().isNotEmpty) {
      final normalized = _normalizeRawBackendString(data);
      return normalized;
    }

    return null;
  }

  static String? _normalizeRawBackendString(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final lower = text.toLowerCase();

    if (lower.contains('413 request entity too large') ||
        lower.contains('request entity too large') ||
        lower.contains('<title>413')) {
      return 'Размер файла слишком большой.';
    }

    if (lower.contains('payload too large')) {
      return 'Размер файла слишком большой.';
    }

    if (lower.contains('<html') || lower.contains('<!doctype html')) {
      return 'Сервер вернул некорректный формат ошибки.';
    }

    return text;
  }
}
