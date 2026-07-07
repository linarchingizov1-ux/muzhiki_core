import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/appbar_main/appbar_main.dart';

class SliverHomeAppbarWidget extends StatelessWidget {
  final TypeApp typeApp;
  final SessionApp? sessionApp;
  const SliverHomeAppbarWidget({
    super.key,
    required this.typeApp,
    this.sessionApp,
  });

  @override
  Widget build(BuildContext context) {
    if (typeApp == TypeApp.support && sessionApp != null) {
      return SupportAppBar(sessionApp: sessionApp!);
    } else {
      return SliverPadding(
        padding: EdgeInsetsGeometry.only(bottom: 5.h),
        sliver: SliverAppBar(
          centerTitle: false,
          pinned: true,
          floating: true,
          title: Text(
            'Мои чаты',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          leading: InkWell(
            onTap: context.pop,
            child: Icon(Icons.arrow_back_ios_new_rounded, size: 20.r),
          ),
          leadingWidth: 40.w,
          titleSpacing: 0,
        ),
      );
    }
  }
}
