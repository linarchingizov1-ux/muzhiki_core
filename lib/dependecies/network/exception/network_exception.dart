import 'package:muzhiki_core/dependecies/exception/global_exception.dart';

class NetworkExceptionApp extends GlobalExceptionApp {
  final int? statusCode;

  const NetworkExceptionApp({
    required super.message,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
}
