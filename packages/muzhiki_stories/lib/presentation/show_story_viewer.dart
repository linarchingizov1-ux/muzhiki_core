import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/domain/entity/story_action_entity.dart';
import 'package:muzhiki_stories/presentation/home_redesign_story_view.dart';
import 'package:muzhiki_stories/presentation/state/stories_view_model.dart';

Future<void> showStoryViewer(
  BuildContext context, {
  required StoriesViewModel viewModel,
  required ValueNotifier<List<StoryModel>> stories,
  int initialStoryIndex = 0,
  int initialItemIndex = 0,
  bool lockToSingleStory = false,
  FutureOr<void> Function(StoryActionEntity action)? onAction,
  FutureOr<void> Function()? onClosed,
  bool useRootNavigator = true,
}) async {
  final route = PageRouteBuilder<void>(
    opaque: false,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: StoryViewer(
          viewModel: viewModel,
          stories: stories,
          initialStoryIndex: initialStoryIndex,
          initialItemIndex: initialItemIndex,
          lockToSingleStory: lockToSingleStory,
          onAction: onAction,
        ),
      );
    },
  );

  await Navigator.of(context, rootNavigator: useRootNavigator).push(route);
  await route.completed;
  await onClosed?.call();
}
