import 'dart:io';

import 'package:muzhiki_support/data/models/socket/socket_connection.dart';
import 'package:muzhiki_support/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_support/shared/widgets/attachment/document_attachment.dart';
import 'package:muzhiki_support/shared/widgets/attachment/photo_attachment.dart';
import 'package:muzhiki_support/shared/widgets/attachment/video_attachment.dart';

abstract class AttachmentWidgets {
  static VideoAttachment video({
    required Directory directory,
    required String url,
    required AppWebsocketChat websocketChat,
  }) => VideoAttachment(
    url: url,
    directory: directory,
    websocketChat: websocketChat,
  );
  static DocumentAttachment document({
    required Directory directory,
    required String url,
    required String fileName,
  }) => DocumentAttachment(url: url, directory: directory, fileName: fileName);
  static PhotoAttachment photo({
    required AppWebsocketChat websocketChat,
    required AttachmentsModel attachment,
  }) => PhotoAttachment(attachment: attachment, websocketChat: websocketChat);
}
