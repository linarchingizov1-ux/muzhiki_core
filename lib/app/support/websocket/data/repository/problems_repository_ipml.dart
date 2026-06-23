import 'package:dio/dio.dart';
import 'package:muzhiki_core/app/support/websocket/domain/repository/problems_repository.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_exception.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_map_error.dart';

class ProblemsRepositoryIpml implements ProblemsRepository {
  const ProblemsRepositoryIpml({required this.authDio});
  final Dio authDio;
  @override
  Future<void> sendProblems({
    required AppException error,
    required String source,
  }) async {
    try {
      await authDio.post(
        "https://api.master.muzhiki.pro/api/v1/problems",
        data: {
          "app": "master-app",
          "description": error.message,
          "source": source,
        },
      );
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }
}
