import 'package:muzhiki_core/muzhiki_support/app/data/model/support_chats_event_widgets.dart';

sealed class SupportAction {
  const SupportAction();
}

class SupportNone extends SupportAction {
  const SupportNone();
}

class SupportCreateSession extends SupportAction {
  final SupportChatsEventWidgets supportChatsEventWidgets;
  const SupportCreateSession({required this.supportChatsEventWidgets});
}

class SupportOpenChat extends SupportAction {
  final String sessionId;

  const SupportOpenChat(this.sessionId);
}
