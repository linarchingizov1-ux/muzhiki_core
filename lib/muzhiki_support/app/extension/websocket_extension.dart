import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/view_image_item_model.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';

extension ChatMediaExtension on AppWebsocketChat {
  List<ViewerImageItem> buildImages() {
    return state.messages
        .expand((m) => m.attachments)
        .where((a) => a.type == ChatAttachmentType.photo)
        .map((a) => ViewerImageItem.network(a.url))
        .toList();
  }
}
