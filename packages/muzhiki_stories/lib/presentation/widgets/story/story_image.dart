import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muzhiki_stories/data/model/story_enums.dart';
import 'package:muzhiki_stories/data/model/story_item_model.dart';
import 'package:muzhiki_stories/presentation/state/stories_view_model.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_image_error_placeholder.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class StoryImage extends StatefulWidget {
  const StoryImage({
    super.key,
    required this.item,
    required this.imageProvider,
    required this.viewModel,
    required this.mode,
    this.alignment = Alignment.center,
    this.showLoader = true,
    this.onImageLoadedChanged,
  });

  final StoryItemModel? item;
  final ImageProvider imageProvider;
  final StoriesViewModel viewModel;
  final StoryFirstScreenMode mode;
  final Alignment alignment;
  final bool showLoader;
  final ValueChanged<bool>? onImageLoadedChanged;

  @override
  State<StoryImage> createState() => _StoryImageState();
}

class _StoryImageState extends State<StoryImage> {
  bool _hasFrame = false;
  bool _hasImageLoadError = false;
  int _imageReloadCount = 0;
  bool _isImageLoadRetrying = false;

  bool get _isImageLoadFailed {
    final item = widget.item;
    return _hasImageLoadError ||
        (item != null && widget.viewModel.isImageLoadFailed(item: item));
  }

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _hasImageLoadError =
        item != null && widget.viewModel.isImageLoadFailed(item: item);
    _notifyImageLoaded(false);
  }

  @override
  void didUpdateWidget(StoryImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldItem = oldWidget.item;
    final item = widget.item;
    final oldStoryImageKey = oldItem == null
        ? null
        : widget.viewModel.storyImageKey(item: oldItem);
    final storyImageKey = item == null
        ? null
        : widget.viewModel.storyImageKey(item: item);

    if (oldStoryImageKey != storyImageKey) {
      _hasFrame = false;
      _hasImageLoadError =
          item != null && widget.viewModel.isImageLoadFailed(item: item);
      _isImageLoadRetrying = false;
      _notifyImageLoaded(false);
      return;
    }

    if (oldWidget.onImageLoadedChanged != widget.onImageLoadedChanged ||
        oldWidget.viewModel != widget.viewModel) {
      _notifyImageLoaded(_hasFrame && !_isImageLoadFailed);
    }
  }

  void _notifyImageLoaded(bool isImageLoaded) {
    final onLoadedChanged = widget.onImageLoadedChanged;
    if (onLoadedChanged == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      onLoadedChanged(
        (widget.item?.imageUrl.isNotEmpty ?? false) && isImageLoaded,
      );
    });
  }

  Future<void> _retryImageLoad() async {
    final item = widget.item;
    if (item == null ||
        (widget.item?.imageUrl.isEmpty ?? false) ||
        _isImageLoadRetrying) {
      return;
    }

    final storyImageKey = widget.viewModel.storyImageKey(item: item);
    widget.viewModel.clearImageLoadFailed(item: item);
    setState(() {
      _isImageLoadRetrying = true;
      _hasFrame = false;
      _hasImageLoadError = false;
    });
    _notifyImageLoaded(false);

    try {
      await widget.viewModel.storyCacheManager.evict(
        imageUrl: item.imageUrl,
        mode: widget.mode,
      );
    } catch (_) {}

    if (!mounted ||
        widget.item == null ||
        widget.viewModel.storyImageKey(item: widget.item!) != storyImageKey) {
      return;
    }

    setState(() {
      _imageReloadCount++;
      _isImageLoadRetrying = false;
    });
  }

  void _setImageLoadFailed(StoryItemModel item) {
    widget.viewModel.setImageLoadFailed(item: item);
    if (_hasImageLoadError) return;

    final storyImageKey = widget.viewModel.storyImageKey(item: item);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          widget.item == null ||
          widget.viewModel.storyImageKey(item: widget.item!) != storyImageKey) {
        return;
      }
      setState(() => _hasImageLoadError = true);
      _notifyImageLoaded(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item == null || (widget.item?.imageUrl.isEmpty ?? false)) {
      return const StoryImageErrorPlaceholder(message: 'Ссылка на фото пустая');
    }

    return ColoredBox(
      color: MuzhikiColors.black17,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.showLoader &&
              (_isImageLoadRetrying || (!_hasFrame && !_isImageLoadFailed)))
            Center(
              child: Transform.scale(
                scale: Platform.isIOS ? 1.25 : 1.0,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2.5,
                  backgroundColor: Platform.isIOS ? MuzhikiColors.white : null,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    MuzhikiColors.white,
                  ),
                ),
              ),
            ),
          if (_isImageLoadFailed && !_isImageLoadRetrying)
            StoryImageErrorPlaceholder(
              message: 'Не удалось загрузить фото',
              onRetry: _retryImageLoad,
            )
          else if (!_isImageLoadRetrying)
            Image(
              key: ValueKey(
                '${widget.viewModel.storyImageKey(item: widget.item!)}-$_imageReloadCount',
              ),
              image: widget.imageProvider,
              fit: BoxFit.cover,
              alignment: widget.alignment,
              width: double.infinity,
              height: double.infinity,
              gaplessPlayback: false,
              errorBuilder: (context, error, stackTrace) {
                _setImageLoadFailed(widget.item!);

                return StoryImageErrorPlaceholder(
                  message: 'Не удалось загрузить фото',
                  onRetry: _retryImageLoad,
                );
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                final hasFrame = wasSynchronouslyLoaded || frame != null;
                if (hasFrame && !_hasFrame) {
                  final storyImageKey = widget.viewModel.storyImageKey(
                    item: widget.item!,
                  );
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted ||
                        widget.item == null ||
                        widget.viewModel.storyImageKey(item: widget.item!) !=
                            storyImageKey) {
                      return;
                    }
                    widget.viewModel.clearImageLoadFailed(item: widget.item!);
                    setState(() {
                      _hasFrame = true;
                      _hasImageLoadError = false;
                    });
                    _notifyImageLoaded(true);
                  });
                }

                return AnimatedOpacity(
                  opacity: hasFrame ? 1 : 0,
                  duration: wasSynchronouslyLoaded
                      ? Duration.zero
                      : const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
            ),
        ],
      ),
    );
  }
}
