import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';
import 'package:mp_master_app/src/features/widgets/interface/notification.dart';
import 'package:mp_master_app/src/features/widgets/effect/skelet.dart';

class ChoiceWidgets extends StatelessWidget {
  final bool isSelected;
  final bool isLoading;
  final String label;
  final int newMessage;
  final void Function(bool)? onSelected;
  const ChoiceWidgets({
    super.key,
    this.newMessage = 0,
    this.isLoading = false,
    required this.onSelected,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppSkelet(
      enable: isLoading,
      ignoreContainer: true,
      child: ChoiceChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
        pressElevation: 15,
        surfaceTintColor: AppColors.white,
        shadowColor: const Color.fromARGB(255, 122, 122, 122),
        chipAnimationStyle: ChipAnimationStyle(
          selectAnimation: AnimationStyle(
            curve: Curves.easeInQuart,
            reverseCurve: Curves.easeOutBack,
            duration: const Duration(milliseconds: 500),
          ),
          enableAnimation: AnimationStyle(
            curve: Curves.easeInSine,
            reverseCurve: Curves.easeInQuint,
            duration: const Duration(seconds: 1),
          ),
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(22.r),
        ),
        backgroundColor: AppColors.light,
        selectedColor: AppColors.black1,
        disabledColor: Colors.red,
        elevation: 0,
        showCheckmark: false,
        labelStyle: TextStyle(
          letterSpacing: 0,
          color: isSelected ? AppColors.white : AppColors.black1,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),

            if (newMessage > 0) ...[NotificationWidgets(count: newMessage)],
          ],
        ),
        selected: isSelected,
        onSelected: onSelected,
      ),
    );
  }
}
