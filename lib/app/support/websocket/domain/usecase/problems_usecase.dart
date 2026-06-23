import 'package:muzhiki_core/app/support/websocket/domain/repository/problems_repository.dart';
import 'package:muzhiki_core/dependecies/network/exception/network_exception.dart';

class ProblemsUsecase {
  final ProblemsRepository problemsRepository;
  const ProblemsUsecase(this.problemsRepository);

  Future<void> sendProblems({
    required AppException error,
    required String source,
  }) async =>
      await problemsRepository.sendProblems(error: error, source: source);
}
