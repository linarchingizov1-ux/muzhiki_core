enum StoryFirstScreenMode {
  once,
  always,
  disabled;

  static StoryFirstScreenMode fromJson(String? value) {
    switch (value) {
      case 'once':
        return StoryFirstScreenMode.once;
      case 'always':
        return StoryFirstScreenMode.always;
      case 'disabled':
      default:
        return StoryFirstScreenMode.disabled;
    }
  }
}

enum StoryActionType {
  none,
  deeplink,
  webview,
  browser,
  markdown;

  static StoryActionType fromJson(String? value) {
    switch (value) {
      case 'deeplink':
        return StoryActionType.deeplink;
      case 'webview':
        return StoryActionType.webview;
      case 'browser':
        return StoryActionType.browser;
      case 'markdown':
        return StoryActionType.markdown;
      case 'none':
      default:
        return StoryActionType.none;
    }
  }
}

enum StoryContentType {
  photo,
  video;

  static StoryContentType fromJson(String? value) {
    switch (value) {
      case 'video':
        return StoryContentType.video;
      case 'photo':
      default:
        return StoryContentType.photo;
    }
  }
}
