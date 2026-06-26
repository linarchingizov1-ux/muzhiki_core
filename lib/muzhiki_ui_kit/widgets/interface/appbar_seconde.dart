import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';
import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';
import 'package:mp_master_app/src/features/widgets/interface/button.dart';

class AppbarSeconde extends StatelessWidget {
  final String? label, descripton;
  final void Function() onPressed;
  final GlobalKey? leadingKey;
  final int? counterItem;
  final Color labelColor;
  final double labelSize;
  final bool disablePadding;
  final Color backgroundIconColor;
  const AppbarSeconde({
    super.key,
    this.leadingKey,
    this.labelColor = AppColors.black17,
    this.counterItem,
    this.label,
    this.descripton,
    this.labelSize = 16,
    this.disablePadding = false,
    this.backgroundIconColor = AppColors.alertTextGrey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: disablePadding
          ? EdgeInsets.zero
          : EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top,
              bottom: 20.h,
              left: 17.w,
              right: 17.w,
            ),
      child: SizedBox(
        height: 44.h,
        child: Row(
          children: [
            Stack(
              children: [
                AppButton(
                  key: leadingKey,
                  backgroundColor: backgroundIconColor,
                  mode: ButtonMode.circle,
                  onPressed: onPressed,
                  assetIcon: AppAssetsSvg.arrowBack,
                ),
                if (counterItem != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: AppColors.white,
                      ),
                      child: Text(
                        counterItem.toString(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 19.w),
            if (label != null || descripton != null)
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (label != null)
                            Text(
                              label!,
                              style: TextStyle(
                                height: 1.5.h,
                                fontSize: labelSize.sp,
                                fontWeight: FontWeight.w700,
                                color: labelColor,
                              ),
                            ),
                          if (descripton != null)
                            Text(
                              descripton!,
                              style: TextStyle(
                                height: 1.5.h,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyText,
                              ),
                            ),
                        ],
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
