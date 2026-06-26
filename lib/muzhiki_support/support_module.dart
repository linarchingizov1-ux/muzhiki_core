part of 'package:muzhiki_core/muzhiki_core.dart';

class SupportModuleConfig {
  final String homeRoute;
  final String profileRoute;
  final String versionApp, buildApp;
  final SessionApp session;
  final Dio authDio;
  final Directory directory;

  const SupportModuleConfig({
    required this.authDio,
    required this.homeRoute,
    required this.profileRoute,
    required this.versionApp,
    required this.buildApp,
    required this.session,
    required this.directory,
  });
}

class SupportModule {
  const SupportModule._();
  static final routeConstant = SupportRouteConstant.I;

  static List<RouteBase> routers(SupportModuleConfig config) {
    final ChatUseCase chatUseCase = ChatUseCase(
      ChatRepositoryImpl(config.authDio),
    );
    final ChatCubit chatCubit = ChatCubit(chatUseCase: chatUseCase);
    final AttachmentsCubit attachmentsCubit = AttachmentsCubit(
      dio: config.authDio,
      directory: config.directory,
    );
    return [
      GoRoute(
        path: routeConstant.support,
        name: routeConstant.support,
        builder: (context, state) {
          final action = state.extra is SupportAction
              ? state.extra as SupportAction
              : const SupportNone();
          return SupportView(
            action: action,
            chatCubit: chatCubit,
            homeRoute: config.homeRoute,
            profileRoute: config.profileRoute,
          );
        },
      ),
      GoRoute(
        path: routeConstant.videoView,
        name: routeConstant.videoView,
        builder: (context, state) {
          final url = state.uri.queryParameters['url']!;
          final preview = state.extra as String?;
          return ChatVideoPlayerView(url: url, preview: preview);
        },
      ),
      GoRoute(
        path: routeConstant.chat,
        name: routeConstant.chat,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);

          return ChatView(
            id: id,
            extra: state.extra,
            chatUseCase: chatUseCase,
            session: config.session,
            attachmentsCubit: attachmentsCubit,
            chatCubit: chatCubit,
            directory: config.directory,
          );
        },
      ),
      GoRoute(
        path: routeConstant.informator,
        name: routeConstant.informator,
        builder: (context, state) {
          final initialUrl =
              state.uri.queryParameters['initialUrl'] ??
              'https://bus-wa.muzhiki.pro/?native_app=true';
          return InformatorView(
            initialUrl: initialUrl,
            session: config.session,
            versin: config.versionApp,
            build: config.buildApp,
          );
        },
      ),
    ];
  }
}
