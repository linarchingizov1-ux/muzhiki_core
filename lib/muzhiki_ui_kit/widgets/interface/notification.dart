import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';

class NotificationWidgets extends StatelessWidget {
  final int count;
  final EdgeInsets? padding;
  const NotificationWidgets({super.key, required this.count, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.blood,
        borderRadius: BorderRadius.circular(35.r),
      ),
      child: IntrinsicHeight(
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              letterSpacing: 0,
              wordSpacing: 0,
              height: 1.h,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
