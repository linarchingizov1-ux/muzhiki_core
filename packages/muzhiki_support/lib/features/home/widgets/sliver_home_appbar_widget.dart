import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_dependencies/service/session/session.dart';
import 'package:muzhiki_support/config/support_assets.dart';
import 'package:muzhiki_support/shared/widgets/appbar/appbar_main.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class SliverHomeAppbarWidget extends StatelessWidget {
  final TypeApp typeApp;
  final SessionApp? sessionApp;
  final bool canPop;
  const SliverHomeAppbarWidget({
    super.key,
    required this.canPop,
    required this.typeApp,
    this.sessionApp,
  });

  @override
  Widget build(BuildContext context) {
    if (typeApp == TypeApp.support && sessionApp != null) {
      return SliverAppBar(
        centerTitle: false,
        pinned: true,
        automaticallyImplyLeading: false,

        title: SupportAppBar(sessionApp: sessionApp!),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(bottom: 5.h),
        sliver: SliverAppBar(
          centerTitle: false,
          pinned: true,
          floating: true,
          title: Row(
            spacing: 10.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canPop)
                Padding(
                  padding: EdgeInsets.only(left: 17.w),
                  child: MuzhikiUi.buttons.back(
                    backgroundColor: MuzhikiColors.grey,
                    svgAsset: SupportAssets.I.svg.arrowBack,
                    onTap: context.pop,
                  ),
                ),
              Text(
                'Мои чаты',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          leading: null,
          leadingWidth: 40.w,
          titleSpacing: canPop ? 0 : 25.w,
        ),
      );
    }
  }
}
