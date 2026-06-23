import 'package:muzhiki_core/app/support/websocket/data/model/viewer_image.dart';
import 'package:muzhiki_core/app/support/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/app/support/websocket/data/model/socket_connection.dart';

extension ChatMediaExtension on AppWebsocketChat {
  List<ViewerImageItem> buildImages() {
    return state.messages
        .expand((m) => m.attachments)
        .where((a) => a.type == ChatAttachmentType.photo)
        .map((a) => ViewerImageItem.network(a.url))
        .toList();
  }
}
