import 'package:dio/dio.dart';
import 'package:muzhiki_core/dependecies/exception/global_exception.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_map_error.dart';

class GlobalMapErrorApp {
  const GlobalMapErrorApp._();
  static final I = const GlobalMapErrorApp._();
  static GlobalExceptionApp map(Object error, [StackTrace? stackTrace]) {
    if (error is GlobalExceptionApp) {
      return error;
    }

    if (error is DioException) {
      return NetworkMapErrorApp.I.map(error);
    }

    if (error is TypeError) {
      return GlobalExceptionApp(
        message: 'Ошибка обработки данных.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return GlobalExceptionApp(
        message: 'Некорректный формат данных.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is RangeError) {
      return GlobalExceptionApp(
        message: 'Ошибка при чтении данных.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is NoSuchMethodError) {
      return GlobalExceptionApp(
        message: 'При обработке данных произошла ошибка.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return GlobalExceptionApp(
      message: 'Произошла неизвестная ошибка.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}
