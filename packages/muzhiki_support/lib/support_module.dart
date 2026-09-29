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

class StateModule {
  final ChatUseCase chatUseCase;
  final ChatCubit chatCubit;
  final AttachmentsCubit attachmentsCubit;
  const StateModule({
    required this.chatUseCase,
    required this.chatCubit,
    required this.attachmentsCubit,
  });
}

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

  static StateModule? _stateModule;

  static StateModule createStateModule({required SupportModuleConfig config}) {
    final existing = _stateModule;
    print(
      '🏭 createStateModule: '
      'stateModule=${existing?.hashCode}, '
      'chatCubit=${existing?.chatCubit.hashCode}',
    );
    return _stateModule ??= (() {
      final chatUseCase = ChatUseCase(ChatRepositoryImpl(config.authDio));

      final chatCubit = ChatCubit(chatUseCase: chatUseCase);

      final attachmentsCubit = AttachmentsCubit(
        dio: config.authDio,
        directory: config.directory,
      );

      final module = StateModule(
        chatUseCase: chatUseCase,
        chatCubit: chatCubit,
        attachmentsCubit: attachmentsCubit,
      );

      print(
        '🆕 CREATED StateModule: '
        'module=${module.hashCode}, '
        'chatCubit=${module.chatCubit.hashCode}',
      );

      return module;
    })();
  }

  static List<RouteBase> routers({
    required SupportModuleConfig config,
    bool? showInformator,
  }) {
    final stateModule = createStateModule(config: config);
    print(
      '🛣️ SUPPORT ROUTE '
      'module=${identityHashCode(stateModule)} '
      'cubit=${identityHashCode(stateModule.chatCubit)}',
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
            chatCubit: stateModule.chatCubit,
            homeRoute: config.homeRoute,
            profileRoute: config.profileRoute,
          );
        },
      ),
      GoRoute(
        path: routeConstant.chatDraft,
        name: routeConstant.chatDraft,
        builder: (context, state) {
          return ChatView(
            id: null,
            extra: state.extra,
            chatUseCase: stateModule.chatUseCase,
            session: config.session,
            attachmentsCubit: stateModule.attachmentsCubit,
            chatCubit: stateModule.chatCubit,
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
            chatUseCase: stateModule.chatUseCase,
            session: config.session,
            attachmentsCubit: stateModule.attachmentsCubit,
            chatCubit: stateModule.chatCubit,
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
            buildV: config.buildApp,
          );
        },
      ),
    ];
  }
}
