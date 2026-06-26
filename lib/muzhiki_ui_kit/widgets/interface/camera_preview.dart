import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';
import 'package:mp_master_app/src/core/dependencies/cameras.dart';

class CameraPreviewApp extends StatelessWidget {
  const CameraPreviewApp({super.key, required this.cameraZoomManager});

  final CameraZoomManager? cameraZoomManager;

  @override
  Widget build(BuildContext context) {
    final controller = cameraZoomManager?.controller;

    if (controller == null) {
      return const Material(color: Colors.black, child: _PlaceholderCamera());
    }

    return Material(
      color: Colors.black,
      child: ValueListenableBuilder<CameraValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          final previewSize = value.previewSize;
          final cameraNotReady = !value.isInitialized || previewSize == null;

          if (cameraNotReady) {
            return const _PlaceholderCamera();
          }

          final screenSize = MediaQuery.of(context).size;
          final previewRatio = previewSize.height / previewSize.width;
          final screenRatio = screenSize.height / screenSize.width;

          return ClipRect(
            child: OverflowBox(
              alignment: Alignment.center,
              maxWidth: screenRatio > previewRatio
                  ? screenSize.height / previewRatio
                  : screenSize.width,
              maxHeight: screenRatio > previewRatio
                  ? screenSize.height
                  : screenSize.width * previewRatio,
              child: CameraPreview(controller).animate().fade(duration: 350.ms),
            ),
          );
        },
      ),
    );
  }
}

class _PlaceholderCamera extends StatelessWidget {
  const _PlaceholderCamera();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
        child: Image.asset(AppAssetsPng.blur, fit: BoxFit.cover),
      ),
    );
  }
}
