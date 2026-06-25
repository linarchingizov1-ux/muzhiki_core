import 'package:muzhiki_core/muzhiki_support/app/data/model/my_chat.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';

abstract class ChatRepository {
  Future<MyChatModel> getMyChats({required int page});
  Future getMyChannel();
  Future<int> createSession({required int channelId});
  Future<SocketConnectionModel> getMessageChat({required int sessionId});
  // Future<MobileWidgetModel?> getMobileWidget();
  Future<bool> reopenWebChat({required int sessionId});
  Future<bool> postScoreWebChat({required int sessionId, required int score});
}
