abstract class ReportProblemRepository {
  Future<bool> sendBugReport({
    required Map<String, dynamic> payload,
    String? screenshotPath,
  });
}
