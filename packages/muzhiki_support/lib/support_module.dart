import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_dependencies/service/session/session.dart';
import 'package:muzhiki_support/config/support_route_constant.dart';
import 'package:muzhiki_support/config/support_route_event.dart';
import 'package:muzhiki_support/data/repositories/chat_repository_impl.dart';
import 'package:muzhiki_support/domain/usecases/chat_usecase.dart';
import 'package:muzhiki_support/features/chat/chat_view.dart';
import 'package:muzhiki_support/features/informator/informator_view.dart';
import 'package:muzhiki_support/features/home/support_view.dart';
import 'package:muzhiki_support/features/chat/state/attachments_cubit.dart';
import 'package:muzhiki_support/features/home/state/chat_cubit.dart';
import 'package:muzhiki_support/shared/widgets/video_player.dart';

class SupportModuleConfig {
  final String homeRoute;
  final String profileRoute;
  final String versionApp, buildApp;
  final SessionApp session;
  final Dio authDio;
  final Directory directory;
  final TypeApp typeApp;
  final void Function()? firebaseRemoveFCM;
  const SupportModuleConfig({
    this.firebaseRemoveFCM,
    required this.typeApp,
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

  static List<RouteBase> routers({
    required SupportModuleConfig config,
    bool? showInformator,
  }) {
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
          final isAllowedInformator =
              showInformator ??
              config.session.user != null &&
                  config.session.user!.isAllowedAccessInformator;
          return SupportView(
            firebaseRemoveFCM: config.firebaseRemoveFCM,
            sessionApp: config.session,
            typeApp: config.typeApp,
            showInformator: isAllowedInformator,
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
        path: routeConstant.chatDraft,
        name: routeConstant.chatDraft,
        builder: (context, state) {
          return ChatView(
            id: null,
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
              'https://bus-wa.muzhiki.pro';
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
