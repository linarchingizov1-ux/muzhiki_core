import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:muzhiki_dependencies/network/exception/network_map_error.dart';
import 'package:muzhiki_report_problem/config/report_problem_path.dart';
import 'package:muzhiki_report_problem/domain/repository/report_problem_repository.dart';
import 'package:talker/talker.dart';

class ReportProblemRepositoryImpl implements ReportProblemRepository {
  ReportProblemRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> sendBugReport({
    required Map<String, dynamic> payload,
    String? screenshotPath,
  }) async {
    try {
      Talker().debug("Данные которые отправляю:\n$payload");
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
      Talker().error("Ошибка:\n$e\nStack: $st");
      throw AppErrorMapper.I.map(e, st);
    }
  }
}
