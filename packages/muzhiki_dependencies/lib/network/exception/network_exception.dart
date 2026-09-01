class AppException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  String _truncate(String input, int maxLength) {
    if (input.length <= maxLength) return input;
    return '${input.substring(0, maxLength)}...';
  }

  String? get debugMessage {
    final location = stackTrace?.toString().split('\n').first.trim();

    final error = originalError?.toString();
    final shortError = error != null ? _truncate(error, 30) : null;

    return [
      message,
      if (shortError != null) 'Ошибка: $shortError',
      if (location != null) 'Место: $location',
    ].join('\n');
  }

  @override
  String toString() => message;
}

class AppNetworkException extends AppException {
  final int? statusCode;

  const AppNetworkException({
    required super.message,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
}
