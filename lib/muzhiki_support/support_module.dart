// import 'package:go_router/go_router.dart';
// import 'package:muzhiki_core/muzhiki_support/app/config/app_router.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/chat_view/chat_view.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/informator/informator_view.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/main_view/support_view.dart';
// import 'package:muzhiki_core/muzhiki_support/app/feature/presentation/video_view/video_player.dart';

// class SupportModule {
//   const SupportModule._();
//   static final routeConstant = SupportRouteConstant.I;
//   static final List<RouteBase> routers = [
//     GoRoute(
//       path: routeConstant.support,
//       name: routeConstant.support,
//       builder: (context, state) {
//         return SupportView(extra: state.extra);
//       },
//     ),
//     GoRoute(
//       path: routeConstant.videoView,
//       name: routeConstant.videoView,
//       builder: (context, state) {
//         final url = state.uri.queryParameters['url']!;
//         final preview = state.extra as String?;
//         return ChatVideoPlayerView(url: url, preview: preview);
//       },
//     ),
//     GoRoute(
//       path: routeConstant.chat,
//       name: routeConstant.chat,
//       builder: (context, state) {
//         final id = int.parse(state.pathParameters['id']!);

//         return ChatView(id: id, extra: state.extra);
//       },
//     ),
//     GoRoute(
//       path: routeConstant.informator,
//       name: routeConstant.informator,
//       builder: (context, state) {
//         final initialUrl =
//             state.uri.queryParameters['initialUrl'] ??
//             'https://bus-wa.muzhiki.pro/?native_app=true';
//         return InformatorView(initialUrl: initialUrl);
//       },
//     ),
//   ];
// }
