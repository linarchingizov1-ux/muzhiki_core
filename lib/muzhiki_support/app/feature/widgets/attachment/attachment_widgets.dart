import 'dart:io';

import 'package:muzhiki_core/muzhiki_support/app/data/model/socket/socket_connection.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/websocket/chat_websocket_app.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/attachment/document_attachment.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/attachment/photo_attachment.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/attachment/video_attachment.dart';

abstract class AttachmentWidgets {
  static VideoAttachment video({
    required Directory directory,
    required String url,
  }) => VideoAttachment(url: url, directory: directory);
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
