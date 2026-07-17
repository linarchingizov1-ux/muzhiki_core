import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/button.dart';
import 'package:muzhiki_core/muzhiki_report_problem/config/report_problem_colors.dart';
import 'package:muzhiki_core/muzhiki_report_problem/config/report_problem_assets.dart';

class SuccessDialog extends StatelessWidget {
  final String title;

  const SuccessDialog({super.key, this.title = 'Заявка отправлена'});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 21.h),
        SvgPicture.asset(
          ReportProblemAssets.successRequestSVG,
          width: 135.r,
          height: 135.r,
        ),
        SizedBox(height: 21.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            height: 1.3,
            fontWeight: FontWeight.w600,
            color: ReportProblemColors.black23,
          ),
        ),
        SizedBox(height: 27.h),
        AppButton(
          mode: ButtonMode.classic,
          label: 'Отлично',
          backgroundColor: ReportProblemColors.black23,
          labelColor: ReportProblemColors.white,
          borderRadius: 23,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
