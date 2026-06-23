import 'package:flutter/widgets.dart';
import 'package:muzhiki_core/app/support/websocket/chat_websocket_app.dart';

class SupportApp {
  final AppWebsocketChat websocket;
  final SupportWidgets ui;
  const SupportApp({required this.websocket, required this.ui});
}

class SupportWidgets {
  final Widget textField, chat, mainPage;
  final Widget? informator;
  final bool showInformator;
  const SupportWidgets({
    required this.textField,
    required this.chat,
    required this.mainPage,
    this.informator,
    required this.showInformator,
  });
}
