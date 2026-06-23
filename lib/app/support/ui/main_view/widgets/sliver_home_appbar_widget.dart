import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SliverHomeAppbarWidget extends StatelessWidget {
  const SliverHomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
