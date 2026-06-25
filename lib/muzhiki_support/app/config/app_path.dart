class SupportPath {
  const SupportPath._();
  static const _baseSupportURL = 'https://api.webchat.muzhiki.pro';
  static const getMyChannel =
      'https://api.erp.muzhiki.pro/api/v1/messenger/channels';
  static const myChat = 'https://api.webchat.muzhiki.pro/my-chats';
  static const uploadAttachments =
      'https://api.webchat.muzhiki.pro/attachments/upload';
  static const createSession = 'https://api.webchat.muzhiki.pro/create-session';
  static const getMobileWidgets =
      'https://api.webchat.muzhiki.pro/get-mobile-widget';
  static const reopenWebChat = 'https://api.webchat.muzhiki.pro/session-reopen';
  static const postScoreWebChat = 'https://api.webchat.muzhiki.pro/set-score';
  static String getMessageChat({required int sessionId}) =>
      '$_baseSupportURL/chat/$sessionId';
}
