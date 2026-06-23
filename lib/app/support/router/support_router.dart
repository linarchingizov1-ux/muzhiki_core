// import 'package:go_router/go_router.dart';
// import 'package:muzhiki_core/app/support/ui/chat_view/chat_view.dart';
// import 'package:muzhiki_core/app/support/ui/informator/informator_view.dart';
// import 'package:muzhiki_core/app/support/ui/main_view/support_view.dart';
// import 'package:muzhiki_core/app/support/ui/widgets/video_player.dart';

// class SupportRouter {
//   SupportRouter._();

//   static final I = SupportRouter._();

//   final List<GoRoute> supportRouters = [
//     GoRoute(
//       path: '/video-view',
//       name: '/video-view',
//       builder: (context, state) {
//         final url = state.uri.queryParameters['url']!;
//         final preview = state.extra as String?;
//         return ChatVideoPlayerView(url: url, preview: preview);
//       },
//     ),
//     GoRoute(
//       path: '/chat/:id',
//       name: '/chat/:id',
//       builder: (context, state) {
//         final id = int.parse(state.pathParameters['id']!);

//         return ChatView(id: id, extra: state.extra);
//       },
//     ),
//     GoRoute(
//       path: '/support',
//       name: '/support',
//       builder: (context, state) {
//         return SupportView(extra: state.extra);
//       },
//     ),
//     GoRoute(
//       path: '/informator',
//       name: '/informator',
//       builder: (context, state) {
//         final initialUrl =
//             state.uri.queryParameters['initialUrl'] ??
//             'https://bus-wa.muzhiki.pro/?native_app=true';
//         return InformatorView(initialUrl: initialUrl);
//       },
//     ),
//   ];
// }
