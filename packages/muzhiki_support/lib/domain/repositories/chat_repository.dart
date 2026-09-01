import 'package:muzhiki_dependencies/network/exception/network_exception.dart';
import 'package:muzhiki_support/data/models/my_chat.dart';
import 'package:muzhiki_support/data/models/socket/socket_connection.dart';

abstract class ChatRepository {
  Future<MyChatModel> getMyChats({required int page});
  Future getMyChannel();
  Future<int> createSession({required int channelId});
  Future<SocketConnectionModel> getMessageChat({required int sessionId});
  Future<bool> reopenWebChat({required int sessionId});
  Future<bool> postScoreWebChat({required int sessionId, required int score});
  Future<void> sendProblems({
    required AppException error,
    required String source,
  });
}
