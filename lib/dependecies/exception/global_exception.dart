class GlobalExceptionApp implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;

  const GlobalExceptionApp({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  String? get debugMessage {
    final location = stackTrace?.toString().split('\n').first.trim();

    return [
      message,
      if (originalError != null) 'Ошибка: $originalError',
      if (location != null && location.isNotEmpty) 'Место: $location',
    ].join('\n');
  }

  @override
  String toString() => message;
}
