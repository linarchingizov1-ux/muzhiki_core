import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/config/report_problem_path.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/domain/repository/report_problem_repository.dart';

class ReportProblemRepositoryImpl implements ReportProblemRepository {
  ReportProblemRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> sendBugReport({
    required Map<String, dynamic> payload,
    String? screenshotPath,
  }) async {
    try {
      final response = await _dio.post(
        ReportProblemPath.bugReports,
        data: FormData.fromMap({
          'payload': MultipartFile.fromString(
            jsonEncode(payload),
            contentType: DioMediaType('application', 'json'),
          ),
          if (screenshotPath != null)
            'screenshot': await MultipartFile.fromFile(screenshotPath),
        }),
      );

      return response.data['success'] == true;
    } catch (e, st) {
      throw throw AppErrorMapper.I.map(e, st);
    }
  }
}
