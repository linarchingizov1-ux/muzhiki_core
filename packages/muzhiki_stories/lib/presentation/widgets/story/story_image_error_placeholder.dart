import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class StoryImageErrorPlaceholder extends StatelessWidget {
  const StoryImageErrorPlaceholder({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MuzhikiColors.black17,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 44.r,
              color: MuzhikiColors.white,
            ),
            SizedBox(height: 14.h),
            Text(
              'Не удалось загрузить фото',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: MuzhikiColors.white,
              ),
            ),
            SizedBox(height: 18.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 28.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: MuzhikiColors.white,
                  borderRadius: BorderRadius.circular(41.r),
                ),
                child: Text(
                  'Повторить',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: MuzhikiColors.black17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
