import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:muzhiki_report_problem/domain/repository/report_problem_repository.dart';

class ReportProblemRepositoryImpl implements ReportProblemRepository {
  ReportProblemRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> sendBugReport({
    required Map<String, dynamic> payload,
    String? screenshotPath,
  }) async {
    final response = await _dio.post(
      "https://metrics.dev.muzhiki.pro/api/v1/bug-reports",
      data: FormData.fromMap({
        'payload': MultipartFile.fromString(
          jsonEncode(payload),
          contentType: DioMediaType('application', 'json'),
        ),
        if (screenshotPath != null)
          'screenshot': await MultipartFile.fromFile(screenshotPath),
      }),
    );

    final data = response.data;
    return data is Map && data['success'] == true;
  }
}
