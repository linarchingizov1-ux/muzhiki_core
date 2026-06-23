import 'package:muzhiki_core/app/support/websocket/data/model/mobile_widget.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/my_chat.dart';
import 'package:muzhiki_core/app/support/websocket/domain/repository/chat_repository.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';

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

  Future<MobileWidgetModel?> getMobileWidget() async =>
      await _chatRepository.getMobileWidget();

  Future<bool> reopenWebChat({required int sessionId}) async =>
      await _chatRepository.reopenWebChat(sessionId: sessionId);

  Future<bool> postScoreWebChat({
    required int sessionId,
    required int score,
  }) async => await _chatRepository.postScoreWebChat(
    sessionId: sessionId,
    score: score,
  );
}
