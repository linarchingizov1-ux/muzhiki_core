import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_route_constant.dart';

class SliverInformator extends StatelessWidget {
  const SliverInformator({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsGeometry.only(left: 17.w, right: 17.w, bottom: 20.h),
      sliver: SliverToBoxAdapter(
        child: InkWell(
          onTap: () {
            context.pushNamed(SupportRouteConstant.I.informator);
          },
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.r),
              color: SupportColors.black17,
              image: DecorationImage(
                alignment: AlignmentGeometry.centerRight,
                image: AssetImage(SupportAssets.I.png.informatorBackground),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Информатор',
                  style: TextStyle(
                    color: SupportColors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Аудиты и детализация по СМС',
                  style: TextStyle(
                    color: SupportColors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
