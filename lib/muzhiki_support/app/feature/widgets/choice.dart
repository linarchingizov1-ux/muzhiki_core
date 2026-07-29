import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/notification.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/skelet.dart';

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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48.r),
          color: isSelected ? SupportColors.black1 : SupportColors.light,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? SupportColors.white : SupportColors.black1,
              ),
            ),

            if (newMessage > 0) ...[NotificationWidgets(count: newMessage)],
          ],
        ),
      ),
      // ChoiceChip(
      //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      //   pressElevation: 15,
      //   surfaceTintColor: SupportColors.white,
      //   shadowColor: const Color.fromARGB(255, 122, 122, 122),
      //   chipAnimationStyle: ChipAnimationStyle(
      //     selectAnimation: AnimationStyle(
      //       curve: Curves.easeInQuart,
      //       reverseCurve: Curves.easeOutBack,
      //       duration: const Duration(milliseconds: 500),
      //     ),
      //     enableAnimation: AnimationStyle(
      //       curve: Curves.easeInSine,
      //       reverseCurve: Curves.easeInQuint,
      //       duration: const Duration(seconds: 1),
      //     ),
      //   ),
      //   side: BorderSide.none,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadiusGeometry.circular(22.r),
      //   ),
      //   backgroundColor: SupportColors.light,
      //   selectedColor: SupportColors.black1,
      //   disabledColor: Colors.red,
      //   elevation: 0,
      //   showCheckmark: false,
      //   labelStyle: TextStyle(
      //     letterSpacing: 0,
      //     color: isSelected ? SupportColors.white : SupportColors.black1,
      //     fontSize: 15.sp,
      //     fontWeight: FontWeight.w500,
      //   ),
      //   label: ,
      //   selected: isSelected,
      //   onSelected: onSelected,
      // ),
    );
  }
}
