import 'package:muzhiki_support/data/models/support_chats_event_widgets.dart';

sealed class SupportAction {
  const SupportAction();
}

class SupportNone extends SupportAction {
  const SupportNone();
}

class SupportOpenInformator extends SupportAction {
  final String? initalURL;
  const SupportOpenInformator({this.initalURL});
}

class SupportCreateSession extends SupportAction {
  final SupportChatsEventWidgets supportChatsEventWidgets;
  const SupportCreateSession({required this.supportChatsEventWidgets});
}

class SupportOpenChat extends SupportAction {
  final String sessionId;

  const SupportOpenChat(this.sessionId);
}
