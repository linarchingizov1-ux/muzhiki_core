import 'package:muzhiki_core/dependecies/network/exception/network_exception.dart';

abstract class ProblemsRepository {
  Future<void> sendProblems({
    required AppException error,
    required String source,
  });
}
