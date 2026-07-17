import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/config/core_colors.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/config/report_problem_config.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/presentation/report_problem_dialog.dart';
import 'package:muzhiki_core/muzhiki_ui_kit/presentation/widgets/app_standart_dialog.dart';
import 'package:shake/shake.dart';

class ShakeReportListener extends StatefulWidget {
  final ReportProblemConfig config;
  final Widget child;

  const ShakeReportListener({
    super.key,
    required this.config,
    required this.child,
  });

  @override
  State<ShakeReportListener> createState() => _ShakeReportListenerState();
}

class _ShakeReportListenerState extends State<ShakeReportListener> {
  ShakeDetector? _detector;
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _detector = ShakeDetector.autoStart(
      minimumShakeCount: 2,
      shakeThresholdGravity: 1.7,
      shakeSlopTimeMS: 100,
      onPhoneShake: (_) => _openDialog(),
    );
  }

  Future<void> _openDialog() async {
    if (_isDialogOpen) return;
    _isDialogOpen = true;
    try {
      await AppStandartDialog.open<void>(
        backgroundColor: CoreColors.appBackgroud,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22.r),
          bottom: Radius.circular(
            MuzhikiDependencies.I.divesRadius?.bottomLeft ?? 32.r,
          ),
        ),
        outerPadding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
          top: 8.h,
          bottom: 20.h,
        ),
        child: ReportProblemDialog(config: widget.config),
      );
    } finally {
      _isDialogOpen = false;
    }
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
