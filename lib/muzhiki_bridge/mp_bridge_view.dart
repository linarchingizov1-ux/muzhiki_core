part of 'package:muzhiki_core/muzhiki_core.dart';

class MpBridgeWebView extends StatefulWidget {
  final bool showAppBar;
  final String initialUrl;
  final String version, build;
  final bool needCamera;
  final String? companyId;
  final SessionApp session;
  final List<int>? masterAudit;

  const MpBridgeWebView({
    super.key,
    this.showAppBar = true,
    this.needCamera = false,
    this.masterAudit,
    required this.initialUrl,
    this.companyId,
    required this.build,
    required this.version,
    required this.session,
  });

  @override
  State<MpBridgeWebView> createState() => MpBridgeWebViewState();
}

class MpBridgeWebViewState extends State<MpBridgeWebView> {
  late BridgeAuthUsecase bridgeAuthUsecase;
  static const _channelName = 'MPBridgeChannel';

  late final WebViewController _controller;
  late final Stream<BridgeSession> _sessionUpdates;
  StreamSubscription? _sessionSubscription;

  bool _bridgeInjectedForCurrentPage = false;
  bool isLoading = true;
  bool disposed = false;

  (String platform, String appVersion, String buildNumber)
  get _platformAppInfo {
    final version = widget.version;
    final buildNumber = widget.build;

    if (Platform.isAndroid) {
      return ('android', version, buildNumber);
    }

    if (Platform.isIOS) {
      return ('ios', version, buildNumber);
    }

    return ('unknown', '', '');
  }

  @override
  void initState() {
    super.initState();

    if (widget.needCamera) {
      Permission.camera.request();
    }
    bridgeAuthUsecase = BridgeAuthUsecase(
      repository: BridgeAuthRepositoryImpl(widget.session),
    );
    _sessionUpdates = bridgeAuthUsecase.sessionUpdates;
    _controller = _buildController();
    _listenSessionUpdates();
    bridgeAuthUsecase.seedSession();
    final urlParse = widget.companyId != null
        ? "${widget.initialUrl}?native_app=true&show_header=${widget.showAppBar}&salon_id=${widget.companyId}"
        : widget.masterAudit != null && widget.masterAudit!.isNotEmpty
        ? "${widget.initialUrl}/${widget.masterAudit!.first}/audits/${widget.masterAudit!.last}?native_app=true&show_header=${widget.showAppBar}"
        : "${widget.initialUrl}?native_app=true&show_header=${widget.showAppBar}";
    final url = Uri.parse(urlParse);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(url);
    });
  }

  @override
  void dispose() {
    unawaited(logout());
    disposed = true;
    _sessionSubscription?.cancel();
    bridgeAuthUsecase.dispose();
    super.dispose();
  }

  void _listenSessionUpdates() {
    _sessionSubscription?.cancel();

    _sessionSubscription = _sessionUpdates.listen((session) async {
      if (!mounted || disposed) return;

      await _dispatchEvent(
        type: 'auth:tokenUpdated',
        payload: {
          'accessToken': session.accessToken,
          'expiresAt': session.expiresAt,
          'user': session.user,
        },
      );
    });
  }

  Future<void> _handleWebReady(String? requestId) async {
    await _sendAppContext(requestId);

    final session = await bridgeAuthUsecase.getCurrentSession();

    if (session != null) {
      await _dispatchEvent(
        type: 'auth:session',
        payload: {
          'requestId': requestId,
          'accessToken': session.accessToken,
          'expiresAt': session.expiresAt,
          'user': session.user,
        },
      );
    }
  }

  Future<void> _sendAppContext(String? requestId) async {
    await _dispatchEvent(
      type: 'app:context',
      payload: {
        'requestId': requestId,
        'platform': _platformAppInfo.$1,
        'appVersion': _platformAppInfo.$2,
        'buildNumber': _platformAppInfo.$3,
        'environment': kDebugMode ? 'development' : 'production',
      },
    );
  }

  WebViewController _buildController() {
    late final PlatformWebViewControllerCreationParams params;

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
            onPermissionRequest: (request) {
              request.grant();
            },
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..addJavaScriptChannel(
            _channelName,
            onMessageReceived: (JavaScriptMessage message) async {
              await _handleWebMessage(message.message);
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) async {
                _bridgeInjectedForCurrentPage = false;
                await _ensureBridgeInjected();
              },
              onPageFinished: (url) async {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
                await _ensureBridgeInjected();
              },
              onWebResourceError: (error) {
                setState(() {
                  isLoading = false;
                });
                debugPrint(
                  'Web resource error: ${error.description}, '
                  'mainFrame=${error.isForMainFrame}',
                );
              },
            ),
          );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(kDebugMode);
      final androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    if (controller.platform is WebKitWebViewController) {
      final iosController = controller.platform as WebKitWebViewController;
      iosController.setAllowsBackForwardNavigationGestures(true);
    }

    return controller;
  }

  Future<void> _ensureBridgeInjected() async {
    try {
      await _controller.runJavaScriptReturningResult(
        _bootstrapBridgeJs(_platformAppInfo.$1),
      );
      _bridgeInjectedForCurrentPage = true;
    } catch (e) {
      debugPrint('Bridge injection failed: $e');
    }
  }

  String _bootstrapBridgeJs(String platform) {
    final platformJson = jsonEncode(platform);

    return '''
    (function() {
      if (window.MPBridge?.__mpInstalled === true) {
        return true;
      }

      window.MPBridge = {
        __mpInstalled: true,
        platform: $platformJson,
        version: "1.0",

        postMessage: function(messageJson) {
          try {
            window.$_channelName.postMessage(
              typeof messageJson === 'string'
                ? messageJson
                : JSON.stringify(messageJson)
            );
          } catch (e) {
            console.error(e);
          }
        }
      };

      return true;
    })();
    ''';
  }

  Future<void> _handleWebMessage(String raw) async {
    Map<String, dynamic> msg;

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! Map) {
        await _sendError(
          requestId: null,
          code: 'UNAUTHORIZED',
          message: 'Invalid message format',
        );
        return;
      }

      msg = Map<String, dynamic>.from(decoded);
    } catch (_) {
      await _sendError(
        requestId: null,
        code: 'UNAUTHORIZED',
        message: 'Message is not valid JSON',
      );
      return;
    }

    final type = msg['type']?.toString();
    final requestId = msg['requestId']?.toString();

    switch (type) {
      case 'web:ready':
        await _handleWebReady(requestId);
        break;

      case 'app:getContext':
        await _sendAppContext(requestId);
        break;

      case 'auth:getSession':
        await _handleGetSession(requestId);
        break;

      case 'auth:refresh':
        await _handleRefresh(requestId);
        break;

      case 'auth:logout':
        await _handleLogout();
        break;

      default:
        await _sendError(
          requestId: requestId,
          code: 'UNAUTHORIZED',
          message: 'Unsupported bridge command: $type',
        );
    }
  }

  Future<void> _handleGetSession(String? requestId) async {
    try {
      final session = await bridgeAuthUsecase.getCurrentSession();

      if (session == null) {
        await _sendError(
          requestId: requestId,
          code: 'NO_SESSION',
          message: 'Отсутствует активная сессия',
        );
        return;
      }

      await _dispatchEvent(
        type: 'auth:session',
        payload: {
          'requestId': requestId,
          'accessToken': session.accessToken,
          'expiresAt': session.expiresAt,
          'user': session.user,
        },
      );
    } catch (e) {
      await _sendError(
        requestId: requestId,
        code: 'UNAUTHORIZED',
        message: 'Ошибка при получении сессии: $e',
      );
    }
  }

  Future<void> _handleRefresh(String? requestId) async {
    try {
      final session = await bridgeAuthUsecase.refresh();

      await _dispatchEvent(
        type: 'auth:refreshed',
        payload: {
          'requestId': requestId,
          'accessToken': session.accessToken,
          'expiresAt': session.expiresAt,
          'user': session.user,
        },
      );
    } catch (e) {
      await _sendError(
        requestId: requestId,
        code: 'REFRESH_FAILED',
        message: 'Ошибка ревреше в сесии: $e',
      );
    }
  }

  Future<void> _handleLogout() async {
    try {
      await bridgeAuthUsecase.logout();

      await _dispatchEvent(
        type: 'auth:logout',
        payload: {
          'reason': "native_logout",
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      await _sendError(
        requestId: null,
        code: 'UNAUTHORIZED',
        message: 'Logout failed: $e',
      );
    }
  }

  Future<void> logout() async {
    await _dispatchEvent(
      type: 'auth:logout',
      payload: {
        'reason': 'native_logout',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> _sendError({
    required String? requestId,
    required String code,
    required String message,
  }) async {
    await _dispatchEvent(
      type: 'auth:error',
      payload: {'requestId': requestId, 'code': code, 'message': message},
    );
  }

  Future<void> _dispatchEvent({
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    if (disposed || !mounted) return;

    final eventJson = jsonEncode({'type': type, 'payload': payload});

    final js =
        '''
    (function() {
      window.dispatchEvent(new CustomEvent('mp:bridge', {
        detail: $eventJson
      }));
    })();
  ''';

    try {
      if (!_bridgeInjectedForCurrentPage) {
        await _ensureBridgeInjected();
      }

      if (disposed || !mounted) return;

      await _controller.runJavaScript(js);
    } catch (e) {
      debugPrint('Dispatch event failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
