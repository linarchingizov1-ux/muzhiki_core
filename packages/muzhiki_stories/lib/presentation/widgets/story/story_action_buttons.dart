import 'package:flutter/material.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/data/model/story_model.dart';
import 'package:muzhiki_stories/presentation/service/story_controller.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class StoryActionButtons extends StatelessWidget {
  const StoryActionButtons({
    super.key,
    required this.story,
    required this.storyController,
    required this.isDetailOpen,
    required this.onMarkdownAction,
    required this.onFullscreenAction,
  });

  final StoryModel story;
  final StoryController storyController;
  final bool isDetailOpen;
  final VoidCallback onMarkdownAction;
  final VoidCallback onFullscreenAction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FadeTransition(
          opacity: storyController.textOpacity,
          child: IgnorePointer(
            ignoring: !isDetailOpen,
            child:
                story.markdownActionText != null &&
                    story.markdownActionText!.isNotEmpty &&
                    story.markdownActionType != StoryActionType.none
                ? MuzhikiUi.buttons.dark(
                    label: story.markdownActionText!,
                    borderRadius: 41,
                    onPressed: onMarkdownAction,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        FadeTransition(
          opacity: storyController.detailFadeOut,
          child: IgnorePointer(
            ignoring: isDetailOpen,
            child:
                story.fullscreenActionText != null &&
                    story.fullscreenActionText!.isNotEmpty &&
                    story.fullscreenActionType != StoryActionType.none
                ? MuzhikiUi.buttons.primary(
                    label: story.fullscreenActionText!,
                    backgroundColor: MuzhikiColors.greyLight,
                    borderRadius: 41,
                    onPressed: onFullscreenAction,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
