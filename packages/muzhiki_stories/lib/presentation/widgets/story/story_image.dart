import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muzhiki_stories/presentation/service/story_controller.dart';
import 'package:muzhiki_stories/presentation/widgets/story/story_image_error_placeholder.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class StoryImage extends StatefulWidget {
  const StoryImage({
    super.key,
    required this.imageUrl,
    required this.imageProvider,
    required this.storyController,
    this.fit = BoxFit.cover,
    this.onLoadedChanged,
  });

  final String imageUrl;
  final ImageProvider imageProvider;
  final StoryController storyController;
  final BoxFit fit;
  final ValueChanged<bool>? onLoadedChanged;

  @override
  State<StoryImage> createState() => _StoryImageState();
}

class _StoryImageState extends State<StoryImage> {
  bool _hasFrame = false;
  bool _hasImageLoadError = false;
  int _imageReloadCount = 0;
  bool _isImageLoadRetrying = false;

  bool get _isFailed =>
      _hasImageLoadError ||
      widget.storyController.isImageLoadFailed(widget.imageUrl);

  @override
  void initState() {
    super.initState();
    _hasImageLoadError = widget.storyController.isImageLoadFailed(
      widget.imageUrl,
    );
    _notifyImageLoaded(false);
  }

  @override
  void didUpdateWidget(StoryImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrl != widget.imageUrl) {
      _hasFrame = false;
      _hasImageLoadError = widget.storyController.isImageLoadFailed(
        widget.imageUrl,
      );
      _isImageLoadRetrying = false;
      _notifyImageLoaded(false);
      return;
    }

    if (oldWidget.onLoadedChanged != widget.onLoadedChanged) {
      _notifyImageLoaded(_hasFrame && !_isFailed);
    }
  }

  void _notifyImageLoaded(bool isLoaded) {
    final onLoadedChanged = widget.onLoadedChanged;
    if (onLoadedChanged == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      onLoadedChanged(widget.imageUrl.isNotEmpty && isLoaded);
    });
  }

  Future<void> _retryImageLoad() async {
    if (widget.imageUrl.isEmpty || _isImageLoadRetrying) return;

    final imageUrl = widget.imageUrl;
    widget.storyController.clearImageLoadFailed(imageUrl);
    setState(() {
      _isImageLoadRetrying = true;
      _hasFrame = false;
      _hasImageLoadError = false;
    });
    _notifyImageLoaded(false);

    try {
      await widget.imageProvider.evict();
    } catch (_) {}

    if (!mounted || widget.imageUrl != imageUrl) return;

    setState(() {
      _imageReloadCount++;
      _isImageLoadRetrying = false;
    });
  }

  void _markImageLoadFailed(String imageUrl) {
    widget.storyController.markImageLoadFailed(imageUrl);
    if (_hasImageLoadError) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.imageUrl != imageUrl) return;
      setState(() => _hasImageLoadError = true);
      _notifyImageLoaded(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty) {
      return const StoryImageErrorPlaceholder(message: 'Ссылка на фото пустая');
    }

    return ColoredBox(
      color: MuzhikiColors.black17,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_isImageLoadRetrying || (!_hasFrame && !_isFailed))
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
          if (_isFailed && !_isImageLoadRetrying)
            StoryImageErrorPlaceholder(
              message: 'Не удалось загрузить фото',
              onRetry: _retryImageLoad,
            )
          else if (!_isImageLoadRetrying)
            Image(
              key: ValueKey('${widget.imageUrl}-$_imageReloadCount'),
              image: widget.imageProvider,
              fit: widget.fit,
              width: double.infinity,
              height: double.infinity,
              gaplessPlayback: false,
              errorBuilder: (context, error, stackTrace) {
                final imageUrl = widget.imageUrl;
                _markImageLoadFailed(imageUrl);

                return StoryImageErrorPlaceholder(
                  message: 'Не удалось загрузить фото',
                  onRetry: _retryImageLoad,
                );
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                final imageUrl = widget.imageUrl;
                final hasFrame = wasSynchronouslyLoaded || frame != null;
                if (hasFrame && !_hasFrame) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted || widget.imageUrl != imageUrl) return;
                    widget.storyController.clearImageLoadFailed(imageUrl);
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
