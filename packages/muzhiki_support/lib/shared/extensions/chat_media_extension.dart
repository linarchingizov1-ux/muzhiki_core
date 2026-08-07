import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:muzhiki_support/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_ui/media/media_item.dart';

extension ChatMediaExtension on AppWebsocketChat {
  /// Фото + видео из сообщений чата в порядке появления (лента как в Telegram).
  List<MediaItem> buildMedia() {
    return state.messages
        .expand((m) => m.attachments)
        .where(
          (a) =>
              a.type == ChatAttachmentType.photo ||
              a.type == ChatAttachmentType.video,
        )
        .map((a) {
          return switch (a.type) {
            ChatAttachmentType.photo => MediaItem.photoNetwork(
              a.url,
              heroTag: a.url,
            ),
            ChatAttachmentType.video => MediaItem.videoNetwork(
              a.url,
              heroTag: a.url,
            ),
            ChatAttachmentType.document => throw StateError('unreachable'),
          };
        })
        .toList();
  }

  @Deprecated('Use buildMedia()')
  List<MediaItem> buildImages() =>
      buildMedia().where((e) => e.isPhoto).toList();
}
