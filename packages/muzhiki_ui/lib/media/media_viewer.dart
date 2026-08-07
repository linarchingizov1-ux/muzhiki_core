import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/buttons/muzhiki_buttons.dart';
import 'package:muzhiki_ui/media/media_item.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

export 'media_item.dart';

const _buttons = MuzhikiButtons();

class MediaViewer extends StatefulWidget {
  final List<MediaItem> items;
  final int initialIndex;
  final Color backgroundColor;

  const MediaViewer({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.backgroundColor = MuzhikiColors.black17,
  });

  static Future<T?> open<T>(
    BuildContext context, {
    required List<MediaItem> items,
    int initialIndex = 0,
    Color backgroundColor = MuzhikiColors.black17,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    if (items.isEmpty) return Future.value();

    final index = initialIndex.clamp(0, items.length - 1);

    return Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: MediaViewer(
              items: items,
              initialIndex: index,
              backgroundColor: backgroundColor,
            ),
          );
        },
      ),
    );
  }

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late int _currentIndex;
  late final AnimationController _dragController;

  double _dragDy = 0;
  double _opacity = 1;
  bool _isClosing = false;
  bool _photoZoomed = false;

  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.items.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prepareAround(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dragController.dispose();
    for (final c in _videoControllers.values) {
      c.dispose();
    }
    _videoControllers.clear();
    super.dispose();
  }

  Future<void> _prepareAround(int index) async {
    for (final i in [index - 1, index, index + 1]) {
      if (i < 0 || i >= widget.items.length) continue;
      final item = widget.items[i];
      if (item.isPhoto) {
        try {
          await precacheImage(item.imageProvider, context);
        } catch (_) {}
      } else {
        await _ensureVideo(i);
      }
      if (!mounted) return;
    }

    _pauseAllVideos(except: null);
  }

  Future<VideoPlayerController?> _ensureVideo(int index) async {
    final existing = _videoControllers[index];
    if (existing != null) return existing;

    final item = widget.items[index];
    if (!item.isVideo) return null;

    final controller = item.isNetwork
        ? VideoPlayerController.networkUrl(Uri.parse(item.url!))
        : VideoPlayerController.file(File(item.filePath!));

    _videoControllers[index] = controller;
    try {
      await controller.initialize();
      if (!mounted) return controller;
      setState(() {});
    } catch (_) {
      await controller.dispose();
      _videoControllers.remove(index);
      return null;
    }
    return controller;
  }

  void _pauseAllVideos({int? except}) {
    for (final entry in _videoControllers.entries) {
      if (except != null && entry.key == except) continue;
      if (entry.value.value.isInitialized && entry.value.value.isPlaying) {
        entry.value.pause();
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _photoZoomed = false;
    });
    _pauseAllVideos();
    _prepareAround(index);
  }

  void _close() {
    if (_isClosing) return;
    _isClosing = true;
    _pauseAllVideos();
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isClosing || _photoZoomed) return;
    setState(() {
      _dragDy += details.delta.dy;
      _opacity = (1 - (_dragDy.abs() / 500)).clamp(0.0, 1.0);
    });
  }

  void _animateBack() {
    final start = _dragDy;
    final animation = Tween<double>(begin: start, end: 0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.elasticOut),
    );

    void listener() {
      if (!mounted || _isClosing) return;
      setState(() {
        _dragDy = animation.value;
        _opacity = (1 - (_dragDy.abs() / 500)).clamp(0.0, 1.0);
      });
    }

    animation.addListener(listener);
    _dragController.forward(from: 0).then((_) {
      animation.removeListener(listener);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isClosing || _photoZoomed) return;
    const threshold = 120;
    final velocity = details.primaryVelocity ?? 0;
    if (_dragDy.abs() > threshold || velocity.abs() > 800) {
      _close();
      return;
    }
    _animateBack();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: widget.backgroundColor.withValues(alpha: _opacity),
        body: items.isEmpty
            ? const Center(
                child: Text(
                  'Нет медиа',
                  style: TextStyle(fontFamily: 'Manrope', color: Colors.white),
                ),
              )
            : Stack(
                children: [
                  Positioned(
                    top: 100.h,
                    left: 0,
                    right: 0,
                    bottom: 100.h,
                    child: Transform.translate(
                      offset: Offset(0, _dragDy),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragUpdate: _onDragUpdate,
                        onVerticalDragEnd: _onDragEnd,
                        child: Opacity(
                          opacity: _opacity,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: items.length,
                            physics: _photoZoomed
                                ? const NeverScrollableScrollPhysics()
                                : const BouncingScrollPhysics(),
                            onPageChanged: _onPageChanged,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final isActive = index == _currentIndex;

                              Widget child = item.isPhoto
                                  ? _MediaPhotoPage(
                                      item: item,
                                      onScaleChanged: (zoomed) {
                                        if (!isActive) return;
                                        if (_photoZoomed == zoomed) return;
                                        setState(() => _photoZoomed = zoomed);
                                      },
                                    )
                                  : _MediaVideoPage(
                                      item: item,
                                      controller: _videoControllers[index],
                                      active: isActive,
                                      onTogglePlay: () async {
                                        final c = await _ensureVideo(index);
                                        if (c == null || !mounted) return;
                                        setState(() {
                                          if (c.value.isPlaying) {
                                            c.pause();
                                          } else {
                                            _pauseAllVideos(except: index);
                                            c.play();
                                          }
                                        });
                                      },
                                      onToggleMute: () {
                                        final c = _videoControllers[index];
                                        if (c == null ||
                                            !c.value.isInitialized) {
                                          return;
                                        }
                                        setState(() {
                                          c.setVolume(
                                            c.value.volume == 0 ? 1 : 0,
                                          );
                                        });
                                      },
                                    );

                              if (isActive && item.heroTag != null) {
                                child = Hero(tag: item.heroTag!, child: child);
                              }

                              return child;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45.h,
                    left: 17.w,
                    right: 17.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buttons.close(
                          size: 45,
                          iconSize: 20,
                          onTap: _close,
                          backgroundColor: MuzhikiColors.black1.withValues(
                            alpha: 0.65,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentIndex + 1} / ${items.length}',
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _MediaPhotoPage extends StatelessWidget {
  final MediaItem item;
  final ValueChanged<bool> onScaleChanged;

  const _MediaPhotoPage({required this.item, required this.onScaleChanged});

  @override
  Widget build(BuildContext context) {
    return PhotoView.customChild(
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      minScale: PhotoViewComputedScale.contained,
      initialScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 4,
      scaleStateCycle: (actual) {
        switch (actual) {
          case PhotoViewScaleState.initial:
          case PhotoViewScaleState.covering:
            return PhotoViewScaleState.zoomedIn;
          case PhotoViewScaleState.zoomedIn:
          case PhotoViewScaleState.zoomedOut:
            return PhotoViewScaleState.initial;
          default:
            return PhotoViewScaleState.initial;
        }
      },
      scaleStateChangedCallback: (state) {
        onScaleChanged(state != PhotoViewScaleState.initial);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image(
              image: item.imageProvider,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return child;
              },
              errorBuilder: (_, _, _) {
                return const Center(
                  child: Text(
                    'Не удалось загрузить изображение',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          if (item.hasRemarks)
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.network(
                    item.remarks!,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MediaVideoPage extends StatelessWidget {
  final MediaItem item;
  final VideoPlayerController? controller;
  final bool active;
  final VoidCallback onTogglePlay;
  final VoidCallback onToggleMute;

  const _MediaVideoPage({
    required this.item,
    required this.controller,
    required this.active,
    required this.onTogglePlay,
    required this.onToggleMute,
  });

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final ready = c != null && c.value.isInitialized;
    final preview = item.previewProvider;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (!ready && preview != null)
          Center(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Image(image: preview, fit: BoxFit.contain),
            ),
          )
        else if (ready)
          Center(
            child: AspectRatio(
              aspectRatio: c.value.aspectRatio == 0
                  ? 16 / 9
                  : c.value.aspectRatio,
              child: VideoPlayer(c),
            ),
          )
        else
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        if (ready)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTogglePlay,
              child: Center(
                child: AnimatedOpacity(
                  opacity: c.value.isPlaying ? 0 : 1,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (ready)
          Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: Row(
              children: [
                Expanded(
                  child: VideoProgressIndicator(
                    c,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white24,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleMute,
                  icon: Icon(
                    c.value.volume == 0 ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
