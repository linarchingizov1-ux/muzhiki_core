import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/view_image_item_model.dart';
import 'package:muzhiki_core/muzhiki_ui/muzhiki_ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerPage extends StatefulWidget {
  final List<ViewerImageItem> images;
  final int initialIndex;
  final String? heroTagPrefix;
  const PhotoViewerPage({
    this.heroTagPrefix,
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late int _currentIndex;
  late final List<PhotoViewScaleStateController> _scaleControllers;

  late final AnimationController _dragController;

  double _dragDy = 0;
  double opacity = 1;
  bool _isClosing = false;
  double backgroundOpacity = 1;
  double imageOpacity = 1;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex.clamp(0, widget.images.length - 1);

    _pageController = PageController(initialPage: _currentIndex);

    _scaleControllers = List.generate(
      widget.images.length,
      (_) => PhotoViewScaleStateController(),
    );

    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      cache(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dragController.dispose();

    for (final c in _scaleControllers) {
      c.dispose();
    }

    super.dispose();
  }

  Future<void> cache(int index) async {
    final images = widget.images;

    for (final i in [index, index - 1, index + 1]) {
      if (i < 0 || i >= images.length) continue;

      await precacheImage(images[i].imageProvider, context);
      if (!mounted) return;
    }
  }

  PhotoViewScaleState _scaleStateCycle(PhotoViewScaleState actual) {
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
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isClosing) return;

    setState(() {
      _dragDy += details.delta.dy;

      final progress = (_dragDy.abs() / 500).clamp(0.0, 1.0);

      backgroundOpacity = 1 - progress;
      imageOpacity = 1 - progress * 0.3;
    });
  }

  void _close() {
    _animateClose();
  }

  Future<void> _animateClose({double direction = 1}) async {
    if (_isClosing || !mounted) return;

    _isClosing = true;

    final startDy = _dragDy;

    final animation = Tween<double>(begin: startDy, end: direction * 700)
        .animate(
          CurvedAnimation(parent: _dragController, curve: Curves.easeOutCubic),
        );

    void listener() {
      if (!mounted) return;

      final progress = animation.value == startDy
          ? 0.0
          : ((animation.value - startDy).abs() / (700 - startDy.abs())).clamp(
              0.0,
              1.0,
            );

      setState(() {
        _dragDy = animation.value;

        backgroundOpacity = 1 - progress;
        imageOpacity = 1 - progress * 0.25;
      });
    }

    animation.addListener(listener);

    await _dragController.forward(from: 0);

    animation.removeListener(listener);

    if (!mounted) return;

    context.pop();
  }

  void _animateBack() {
    final start = _dragDy;

    final animation = Tween<double>(begin: start, end: 0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOutBack),
    );

    void listener() {
      if (!mounted || _isClosing) return;

      final progress = (animation.value.abs() / 500).clamp(0.0, 1.0);

      setState(() {
        _dragDy = animation.value;
        backgroundOpacity = 1 - progress;
        imageOpacity = 1 - progress * 0.25;
      });
    }

    animation.addListener(listener);

    _dragController.forward(from: 0).then((_) {
      animation.removeListener(listener);

      if (!mounted || _isClosing) return;

      setState(() {
        _dragDy = 0;
        backgroundOpacity = 1;
        imageOpacity = 1;
      });
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isClosing) return;

    const threshold = 120.0;
    const velocityThreshold = 800.0;

    final velocity = details.primaryVelocity ?? 0;

    final shouldClose =
        _dragDy.abs() > threshold || velocity.abs() > velocityThreshold;

    if (shouldClose) {
      final direction = _dragDy == 0
          ? (velocity >= 0 ? 1.0 : -1.0)
          : (_dragDy > 0 ? 1.0 : -1.0);

      _animateClose(direction: direction);
      return;
    }

    _animateBack();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: widget.images.isEmpty
            ? const Center(child: Text('Нет изображений'))
            : Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: SupportColors.black17.withValues(alpha: opacity),
                      ),
                    ),
                  ),
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
                          opacity: opacity,
                          child: PhotoViewGallery.builder(
                            pageController: _pageController,
                            itemCount: widget.images.length,
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            scrollPhysics: const BouncingScrollPhysics(),
                            onPageChanged: (index) {
                              if (!mounted) return;
                              setState(() => _currentIndex = index);
                            },
                            builder: (context, index) {
                              final item = widget.images[index];

                              final isActive = index == _currentIndex;

                              Widget child = _ZoomableImageLayer(item: item);

                              if (isActive) {
                                child = Hero(
                                  tag:
                                      item.url ??
                                      item.filePath ??
                                      item.xfile?.path ??
                                      'photo_$index',
                                  child: child,
                                );
                              }

                              return PhotoViewGalleryPageOptions.customChild(
                                scaleStateCycle: _scaleStateCycle,
                                minScale: PhotoViewComputedScale.contained,
                                initialScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 4,
                                child: child,
                              );
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
                        MuzhikiUi.buttons.circle(
                          size: 45,
                          iconSize: 20,
                          onTap: _close,
                          icon: Icons.close,
                          backgroundColor: SupportColors.black1.withValues(
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
                            '${_currentIndex + 1} / ${widget.images.length}',
                            style: const TextStyle(
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

class _ZoomableImageLayer extends StatelessWidget {
  final ViewerImageItem item;

  const _ZoomableImageLayer({required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  style: TextStyle(color: Colors.white),
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
    );
  }
}
