import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';

class ScannerPreviewWidgets extends StatefulWidget {
  final MobileScannerController mobileScannerController;
  final void Function(BarcodeCapture)? onDetect;

  const ScannerPreviewWidgets({
    super.key,
    required this.mobileScannerController,
    this.onDetect,
  });

  @override
  State<ScannerPreviewWidgets> createState() => _ScannerWidgetsState();
}

class _ScannerWidgetsState extends State<ScannerPreviewWidgets> {
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: widget.mobileScannerController,
      placeholderBuilder: (context) => const _PlaceholderCamera(),
      onDetect: widget.onDetect,
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
