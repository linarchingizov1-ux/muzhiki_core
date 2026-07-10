import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/data/model/request_enum.dart';

extension DioResponseExtension on Response? {
  int? get responseSizeBytes {
    final response = this;

    if (response == null) return null;

    final contentLength = response.headers.value(Headers.contentLengthHeader);

    return contentLength != null ? int.tryParse(contentLength) : null;
  }

  bool get isSuccess {
    final response = this;

    return response?.statusCode != null &&
        response!.statusCode! >= 200 &&
        response.statusCode! < 300;
  }

  String? get requestId {
    return this?.headers.value('x-request-id');
  }
}

extension DioRequestExtension on RequestOptions {
  int? get requestSizeBytes {
    if (data == null) return null;

    return jsonEncode(data).length;
  }

  RequestMethod get requestMethod {
    return RequestMethod.values.firstWhere(
      (e) => e.name.toUpperCase() == method,
      orElse: () => RequestMethod.get,
    );
  }
}
