import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_exception.dart';

class AppErrorMapper {
  const AppErrorMapper._();

  static final I = const AppErrorMapper._();

  AppException map(Object error, [StackTrace? stackTrace]) {
    if (error is PlatformException) {
      String message;

      switch (error.code) {
        case 'ACTIVITY_NOT_FOUND':
          message =
              'На устройстве не найдено приложение для открытия ссылки\nРекомендуем установить Chrome либо Firefox';
          break;
        case 'PERMISSION_DENIED':
          message =
              'Доступ запрещен. Пожалуйста, проверьте настройки разрешений';
          break;
        case 'LAUNCH_ERROR':
          message =
              'На устройстве не найдено приложение для открытия ссылки внутри приложения';
          break;
        case 'NETWORK_ERROR':
          message = 'Ошибка сети при взаимодействии с платформой';
          break;
        case 'PLAY_SERVICES_NOT_AVAILABLE':
          message = 'Сервисы Google Play недоступны на этом устройстве';
          break;
        case 'CANCELED':
          message = 'Авторизация или просмотр отменены пользователем.';
          break;

        case 'FAILED_TO_LAUNCH_SFSAFARIVIEWCONTROLLER':
          message =
              'Не удалось запустить встроенный браузер. Пожалуйста, вернитесь в приложение и попробуйте снова.';
          break;

        case 'INVALID_URL':
        case 'argument-error':
          message = 'Указана неверная или поврежденная ссылка.';
          break;

        case 'UNSUPPORTED_SCHEME':
          message = 'Тип ссылки не поддерживается вашим устройством.';
          break;

        case 'CHANNEL_ERROR':
          message =
              'Внутренняя ошибка связи с платформой. Перезапустите приложение.';
          break;

        default:
          message = error.message != null && error.message!.isNotEmpty
              ? error.message!
              : 'Произошла непредвиденная ошибка системы.';
      }

      return AppException(
        message: message,
        originalError: error,
        stackTrace: stackTrace,
      );
    }
    if (error is AppException) {
      return error;
    }

    final photoError = PhotoErrorMapper.map(error, stackTrace);
    if (photoError != null) {
      return photoError;
    }

    if (error is DioException) {
      return DioErrorMapper.map(error);
    }

    if (error is TypeError) {
      return AppException(
        message: 'Ошибка обработки данных.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return AppException(
        message: 'Некорректный формат данных.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is RangeError) {
      return AppException(
        message: 'Ошибка при чтении данных.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is NoSuchMethodError) {
      return AppException(
        message: 'При обработке данных произошла ошибка.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return AppException(
      message: 'Произошла неизвестная ошибка.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}

sealed class PhotoPrepareException implements Exception {
  final String path;

  const PhotoPrepareException(this.path);
}

class PhotoFileNotFoundException extends PhotoPrepareException {
  const PhotoFileNotFoundException(super.path);
}

class PhotoFileEmptyException extends PhotoPrepareException {
  const PhotoFileEmptyException(super.path);
}

class PhotoDecodeException extends PhotoPrepareException {
  const PhotoDecodeException(super.path);
}

class PhotoNotEnoughFilesException implements Exception {
  const PhotoNotEnoughFilesException();
}

class PhotoSetIdNotReturnedException implements Exception {
  const PhotoSetIdNotReturnedException();
}

class SupportedUserNotFoundExceptionMap extends AppNetworkException {
  SupportedUserNotFoundExceptionMap({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class SupportedIsFakeUser extends AppNetworkException {
  SupportedIsFakeUser({
    required super.message,
    super.statusCode,
    super.originalError,
  });
}

class PhotoErrorMapper {
  static AppException? map(Object error, [StackTrace? stackTrace]) {
    if (error is PhotoNotEnoughFilesException) {
      return AppException(
        message: 'Недостаточно фото.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is PhotoFileNotFoundException) {
      return AppException(
        message: 'Один из файлов фото не найден.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is PhotoFileEmptyException) {
      return AppException(
        message: 'Один из файлов фото пустой.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is PhotoDecodeException) {
      return AppException(
        message: 'Не удалось обработать одно из изображений.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is PhotoSetIdNotReturnedException) {
      return AppException(
        message: 'Сервер не вернул id фотосета.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return null;
  }
}

class DioErrorMapper {
  static AppNetworkException map(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final error = e.error;

    if (error is AppNetworkException) {
      return error;
    }

    final errorText = error?.toString().toLowerCase() ?? '';
    final messageText = e.message?.toLowerCase() ?? '';
    final combinedText = '$errorText $messageText';

    if (_isNoInternet(error, combinedText)) {
      return AppNetworkException(
        message: 'Нет подключения к интернету. Проверьте соединение.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (_isConnectionInterrupted(error, combinedText)) {
      return AppNetworkException(
        message: 'Соединение было прервано. Попробуйте ещё раз.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (_isTlsOrCertificateError(error, combinedText)) {
      return AppNetworkException(
        message: 'Ошибка безопасного соединения.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.badResponse) {
      final message = _mapStatusCode(statusCode, data);
      final unsuccessUserSupportApp = e.response?.statusCode == 404;
      final isFakeUser = e.response?.statusCode == 403;

      if (unsuccessUserSupportApp) {
        return SupportedUserNotFoundExceptionMap(
          message: message,
          statusCode: statusCode,
          originalError: e,
        );
      }
      if (isFakeUser) {
        return SupportedIsFakeUser(
          message: message,
          statusCode: statusCode,
          originalError: e,
        );
      } else {
        return AppNetworkException(
          message: message,
          statusCode: statusCode,
          originalError: e,
        );
      }
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return AppNetworkException(
        message: 'Превышено время ожидания подключения.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.sendTimeout) {
      return AppNetworkException(
        message: 'Превышено время отправки данных.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return AppNetworkException(
        message: 'Сервер слишком долго отвечает.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.badCertificate) {
      return AppNetworkException(
        message: 'Ошибка сертификата безопасности.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.cancel) {
      return AppNetworkException(
        message: 'Запрос был отменён.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return AppNetworkException(
        message: 'Ошибка интернет-соединения. Проверьте интернет.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    if (e.type == DioExceptionType.unknown) {
      final backendMessage = _extractBackendMessage(data);
      if (backendMessage != null) {
        return AppNetworkException(
          message: backendMessage,
          statusCode: statusCode,
          originalError: e,
        );
      }

      return AppNetworkException(
        message: 'Неизвестная ошибка сети. ${e.error?.runtimeType} ${e.error}.',
        statusCode: statusCode,
        originalError: e,
      );
    }

    return AppNetworkException(
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
        return backendMessage ?? 'Размер файла слишком большой.';
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

    if (data is String && data.trim().isNotEmpty) {
      return data;
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
