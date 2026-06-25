// import 'dart:io';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mp_master_app/src/core/config/color/app_colors.dart';
// import 'package:video_player/video_player.dart';

// class ChatVideoPlayerView extends StatefulWidget {
//   final String url;
//   final String? preview;
//   const ChatVideoPlayerView({super.key, required this.url, this.preview});

//   @override
//   State<ChatVideoPlayerView> createState() => _ChatVideoPlayerViewState();
// }

// class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> {
//   late final VideoPlayerController controller;
//   late final Future<void> initializeFuture;

//   @override
//   void initState() {
//     super.initState();
//     controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
//     initializeFuture = controller.initialize();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   void togglePlay() {
//     if (!controller.value.isInitialized) return;
//     setState(() {
//       if (controller.value.isPlaying) {
//         controller.pause();
//       } else {
//         controller.play();
//       }
//     });
//   }

//   void mute() {
//     if (controller.value.volume == 0) {
//       controller.setVolume(1);
//     } else {
//       controller.setVolume(0);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: FutureBuilder(
//             future: initializeFuture,
//             builder: (context, snapshot) {
//               return Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 550),
//                     child: Builder(
//                       builder: (context) {
//                         if (snapshot.connectionState != ConnectionState.done &&
//                             widget.preview != null &&
//                             widget.preview!.isNotEmpty) {
//                           return Center(
//                             child: ImageFiltered(
//                               imageFilter: ImageFilter.blur(
//                                 sigmaX: 5,
//                                 sigmaY: 5,
//                               ),
//                               child: Container(
//                                 color: Colors.white.withValues(alpha: 0.04),
//                                 child: Image.file(
//                                   fit: BoxFit.cover,
//                                   File(widget.preview!),
//                                 ),
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Center(
//                             child: AspectRatio(
//                               aspectRatio: controller.value.aspectRatio,
//                               child: VideoPlayer(controller),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),

//                   if (snapshot.connectionState == ConnectionState.done)
//                     Positioned.fill(
//                       child: InkWell(
//                         onTap: togglePlay,
//                         child: Center(
//                           child: AnimatedOpacity(
//                             opacity: controller.value.isPlaying ? 0 : 1,
//                             duration: const Duration(milliseconds: 180),
//                             child: Container(
//                               width: 64,
//                               height: 64,
//                               decoration: const BoxDecoration(
//                                 color: Colors.black45,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.play_arrow,
//                                 size: 34,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   else
//                     Positioned.fill(
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ),
//                   Positioned(
//                     left: 16.w,
//                     right: 16.w,
//                     bottom: 20.h,
//                     child: VideoProgressIndicator(
//                       controller,
//                       colors: VideoProgressColors(
//                         playedColor: AppColors.blood,
//                         bufferedColor: AppColors.grey,
//                         backgroundColor: AppColors.light,
//                       ),
//                       allowScrubbing: true,
//                       padding: EdgeInsets.zero,
//                     ),
//                   ),
//                   ValueListenableBuilder(
//                     valueListenable: controller,
//                     builder: (context, value, child) {
//                       final bool muteSound = value.volume == 0;
//                       return Positioned(
//                         right: 16.w,
//                         bottom: 40.h,
//                         child: InkWell(
//                           onTap: mute,
//                           child: Icon(
//                             muteSound ? Icons.volume_off : Icons.volume_up,
//                             color: AppColors.white,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   Positioned(
//                     top: 12,
//                     left: 12,
//                     child: IconButton(
//                       onPressed: () => context.pop(),
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
