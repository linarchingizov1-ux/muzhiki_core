import 'package:muzhiki_dependencies/network/exception/network_exception.dart';
import 'package:muzhiki_support/data/models/my_chat.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:muzhiki_support/domain/repositories/chat_repository.dart';

class ChatUseCase {
  final ChatRepository _chatRepository;
  const ChatUseCase(this._chatRepository);

  Future<MyChatModel> getMyChats({required int page}) async =>
      await _chatRepository.getMyChats(page: page);

  Future getMyChannel() async => await _chatRepository.getMyChannel();

  Future<int> createSession({required int channelId}) async =>
      await _chatRepository.createSession(channelId: channelId);

  Future<SocketConnectionModel> getMessageChat({
    required int sessionId,
  }) async => await _chatRepository.getMessageChat(sessionId: sessionId);

  Future<bool> reopenWebChat({required int sessionId}) async =>
      await _chatRepository.reopenWebChat(sessionId: sessionId);

  Future<bool> postScoreWebChat({
    required int sessionId,
    required int score,
  }) async => await _chatRepository.postScoreWebChat(
    sessionId: sessionId,
    score: score,
  );
  Future<void> sendProblems({
    required AppException error,
    required String source,
  }) => _chatRepository.sendProblems(error: error, source: source);
}
