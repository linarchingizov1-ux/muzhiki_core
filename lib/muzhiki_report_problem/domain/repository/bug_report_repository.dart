abstract class BugReportRepository {
  Future<bool> sendBugReport({
    required Map<String, dynamic> payload,
    String? screenshotPath,
  });
}
