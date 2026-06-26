import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mp_master_app/src/core/dependencies/app_dependencies.dart';
import 'package:mp_master_app/src/data/model/bridge_session.dart';
import 'package:mp_master_app/src/domain/usecase/bridge_auth_usecase.dart';
import 'package:mp_master_app/src/features/main/state/app_version/app_version_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MpBridgeWebView extends StatefulWidget {
  final String initialUrl;
  final BridgeAuthUsecase authRepository;

  const MpBridgeWebView({
    super.key,
    required this.initialUrl,
    required this.authRepository,
  });

  @override
  State<MpBridgeWebView> createState() => MpBridgeWebViewState();
}

class MpBridgeWebViewState extends State<MpBridgeWebView> {
  static const _channelName = 'MPBridgeChannel';

  late final WebViewController _controller;
  late final Stream<BridgeSession> _sessionUpdates;

  bool _bridgeInjectedForCurrentPage = false;
  bool isLoading = true;

  final AppVersionCubit appVersionCubit = getIt<AppVersionCubit>();

  (String platform, String appVersion, String buildNumber)
  get _platformAppInfo {
    final version = appVersionCubit.state.version;
    final buildNumber = appVersionCubit.state.buildNumber;

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

    _sessionUpdates = widget.authRepository.sessionUpdates;
    _controller = _buildController();
    _listenSessionUpdates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(Uri.parse(widget.initialUrl));
    });
  }

  void _listenSessionUpdates() {
    _sessionUpdates.listen((session) async {
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

    final session = await widget.authRepository.getCurrentSession();

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

    final controller = WebViewController.fromPlatformCreationParams(params)
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
        if (window.MPBridge && window.MPBridge.__mpInstalled === true) {
          return true;
        }

        window.MPBridge = {
          __mpInstalled: true,
          platform: $platformJson,
          version: "1.0",

          postMessage: function(messageJson) {
            try {
              $_channelName.postMessage(
                typeof messageJson === 'string'
                  ? messageJson
                  : JSON.stringify(messageJson)
              );
            } catch (e) {
              console.error('MPBridge.postMessage failed', e);
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
      final session = await widget.authRepository.getCurrentSession();

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
      final session = await widget.authRepository.refresh();

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
      await widget.authRepository.logout();

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
      child: isLoading
          ? Center(
              key: const ValueKey('loader'),
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              top: false,
              child: WebViewWidget(
                key: const ValueKey('webview'),
                controller: _controller,
              ),
            ),
    );
  }
}
