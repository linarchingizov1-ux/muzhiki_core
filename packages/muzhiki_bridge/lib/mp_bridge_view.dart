import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muzhiki_bridge/bridge_auth.dart';
import 'package:muzhiki_dependencies/service/session/session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

typedef MpBridgeClearCookies = Future<void> Function();

class MpBridgeWebView extends StatefulWidget {
  final bool showAppBar;
  final String initialUrl;
  final String version, build;
  final String? companyId;
  final SessionApp session;
  final List<int>? masterAudit;
  final void Function(MpBridgeClearCookies clearCookies)? onClearCookiesReady;

  const MpBridgeWebView({
    super.key,
    this.showAppBar = true,
    this.masterAudit,
    required this.initialUrl,
    this.companyId,
    required this.build,
    required this.version,
    required this.session,
    this.onClearCookiesReady,
  });

  @override
  State<MpBridgeWebView> createState() => MpBridgeWebViewState();
}

class MpBridgeWebViewState extends State<MpBridgeWebView> {
  static const _channelName = 'MPBridgeChannel';

  late final BridgeAuth _auth;
  late final WebViewController _controller;
  StreamSubscription<BridgeSession>? _sessionSubscription;

  bool _bridgeInjectedForCurrentPage = false;
  bool isLoading = true;
  bool disposed = false;

  bool get _alive => mounted && !disposed;

  late final String _platform = Platform.isAndroid
      ? 'android'
      : Platform.isIOS
      ? 'ios'
      : 'unknown';

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl.contains('bus-wa')) {
      Permission.camera.request();
    }
    _auth = BridgeAuth(widget.session);
    _controller = _buildController();
    widget.onClearCookiesReady?.call(clearCookies);
    unawaited(_bootstrap());
  }

  Uri get _initialUri {
    final header = 'show_header=${widget.showAppBar}';
    final audit = widget.masterAudit;
    final url = widget.companyId != null
        ? '${widget.initialUrl}?$header&salon_id=${widget.companyId}'
        : audit != null && audit.isNotEmpty
        ? '${widget.initialUrl}/${audit.first}/audits/${audit.last}?$header'
        : '${widget.initialUrl}?$header';
    return Uri.parse(url);
  }

  Future<void> _bootstrap() async {
    // Слушатель до seed, иначе первый auth:tokenUpdated теряется.
    _sessionSubscription = _auth.sessionUpdates.listen((session) {
      if (!_alive) return;
      unawaited(
        _dispatchEvent('auth:tokenUpdated', {
          'accessToken': session.accessToken,
          'expiresAt': session.expiresAt,
          'user': session.user,
        }),
      );
    });
    await _auth.seedSession();
    if (!_alive) return;
    await _controller.loadRequest(_initialUri);
  }

  @override
  void dispose() {
    // Не шлём auth:logout в WebView на dispose — cold/warm remount
    // иначе SPA думает, что пользователь разлогинился.
    disposed = true;
    _sessionSubscription?.cancel();
    _auth.dispose();
    super.dispose();
  }

  Future<void> clearCookies() async {
    try {
      await WebViewCookieManager().clearCookies();
    } catch (e) {
      debugPrint('Clear cookies failed: $e');
    }
  }

  Map<String, dynamic> _sessionPayload(
    BridgeSession session, [
    String? requestId,
  ]) => {
    'requestId': requestId,
    'accessToken': session.accessToken,
    'expiresAt': session.expiresAt,
    'user': session.user,
  };

  Future<void> _sendSession(String? requestId) async {
    final session = await _auth.ensureSession();
    if (session == null) {
      await _sendError(requestId, 'NO_SESSION', 'Отсутствует активная сессия');
      return;
    }
    await _dispatchEvent('auth:session', _sessionPayload(session, requestId));
  }

  Future<void> _sendAppContext(String? requestId) {
    final known = _platform != 'unknown';
    return _dispatchEvent('app:context', {
      'requestId': requestId,
      'platform': _platform,
      'appVersion': known ? widget.version : '',
      'buildNumber': known ? widget.build : '',
      'environment': kDebugMode ? 'development' : 'production',
    });
  }

  WebViewController _buildController() {
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params =
          AndroidWebViewControllerCreationParams.fromPlatformWebViewControllerCreationParams(
            const PlatformWebViewControllerCreationParams(),
          );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller =
        WebViewController.fromPlatformCreationParams(
            params,
            onPermissionRequest: (request) => request.grant(),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..addJavaScriptChannel(
            _channelName,
            onMessageReceived: (message) => _handleWebMessage(message.message),
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                _bridgeInjectedForCurrentPage = false;
                unawaited(_ensureBridgeInjected());
              },
              onPageFinished: (_) async {
                await _ensureBridgeInjected();
                if (mounted) setState(() => isLoading = false);
              },
              onWebResourceError: (error) {
                setState(() => isLoading = false);
                debugPrint(
                  'Web resource error: ${error.description}, '
                  'mainFrame=${error.isForMainFrame}',
                );
              },
            ),
          );

    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(kDebugMode);
      platform.setMediaPlaybackRequiresUserGesture(false);
    } else if (platform is WebKitWebViewController) {
      platform.setAllowsBackForwardNavigationGestures(true);
    }

    return controller;
  }

  Future<void> _ensureBridgeInjected() async {
    try {
      await _controller.runJavaScriptReturningResult('''
        (function() {
          if (window.MPBridge?.__mpInstalled === true) return true;
          window.MPBridge = {
            __mpInstalled: true,
            platform: ${jsonEncode(_platform)},
            version: "1.0",
            postMessage: function(messageJson) {
              try {
                window.$_channelName.postMessage(
                  typeof messageJson === 'string'
                    ? messageJson
                    : JSON.stringify(messageJson)
                );
              } catch (e) { console.error(e); }
            }
          };
          return true;
        })();
      ''');
      _bridgeInjectedForCurrentPage = true;
    } catch (e) {
      debugPrint('Bridge injection failed: $e');
    }
  }

  Future<void> _handleWebMessage(String raw) async {
    late final Map<String, dynamic> msg;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        await _sendError(null, 'UNAUTHORIZED', 'Invalid message format');
        return;
      }
      msg = Map<String, dynamic>.from(decoded);
    } catch (_) {
      await _sendError(null, 'UNAUTHORIZED', 'Message is not valid JSON');
      return;
    }

    final type = msg['type']?.toString();
    final requestId = msg['requestId']?.toString();

    switch (type) {
      case 'web:ready':
        await _sendAppContext(requestId);
        await _sendSession(requestId);
      case 'app:getContext':
        await _sendAppContext(requestId);
      case 'auth:getSession':
        try {
          await _sendSession(requestId);
        } catch (e) {
          await _sendError(
            requestId,
            'UNAUTHORIZED',
            'Ошибка при получении сессии: $e',
          );
        }
      case 'auth:refresh':
        try {
          final session = await _auth.refresh();
          await _dispatchEvent(
            'auth:refreshed',
            _sessionPayload(session, requestId),
          );
        } catch (e) {
          await _sendError(
            requestId,
            'REFRESH_FAILED',
            'Ошибка ревреше в сесии: $e',
          );
        }
      case 'auth:logout':
        try {
          _auth.logout();
          await logout();
        } catch (e) {
          await _sendError(null, 'UNAUTHORIZED', 'Logout failed: $e');
        }
      default:
        await _sendError(
          requestId,
          'UNAUTHORIZED',
          'Unsupported bridge command: $type',
        );
    }
  }

  Future<void> logout() => _dispatchEvent('auth:logout', {
    'reason': 'native_logout',
    'timestamp': DateTime.now().toIso8601String(),
  });

  Future<void> _sendError(String? requestId, String code, String message) =>
      _dispatchEvent('auth:error', {
        'requestId': requestId,
        'code': code,
        'message': message,
      });

  Future<void> _dispatchEvent(String type, Map<String, dynamic> payload) async {
    if (!_alive) return;
    final js =
        '''
    (function() {
      window.dispatchEvent(new CustomEvent('mp:bridge', {
        detail: ${jsonEncode({'type': type, 'payload': payload})}
      }));
    })();
  ''';

    try {
      if (!_bridgeInjectedForCurrentPage) await _ensureBridgeInjected();
      if (!_alive) return;
      await _controller.runJavaScript(js);
    } catch (e) {
      debugPrint('Dispatch event failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (isLoading)
          const Center(child: CircularProgressIndicator.adaptive()),
      ],
    );
  }
}
