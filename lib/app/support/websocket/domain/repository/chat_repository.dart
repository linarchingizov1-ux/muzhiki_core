import 'package:muzhiki_core/app/support/websocket/data/model/mobile_widget.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/my_chat.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';

abstract class ChatRepository {
  Future<MyChatModel> getMyChats({required int page});
  Future getMyChannel();
  Future<int> createSession({required int channelId});
  Future<SocketConnectionModel> getMessageChat({required int sessionId});
  Future<MobileWidgetModel?> getMobileWidget();
  Future<bool> reopenWebChat({required int sessionId});
  Future<bool> postScoreWebChat({required int sessionId, required int score});
}
