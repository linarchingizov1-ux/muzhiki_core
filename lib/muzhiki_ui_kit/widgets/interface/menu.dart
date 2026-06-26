
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';
import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';
import 'package:mp_master_app/src/core/config/constants/app_route_constant.dart';
import 'package:mp_master_app/src/core/dependencies/app_dependencies.dart';

import 'package:mp_master_app/src/core/dependencies/session_app.dart';
import 'package:mp_master_app/src/features/main/state/user/user_cubit.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<UserCubit>(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Добро пожаловать!',
                style: TextStyle(
                  color: AppColors.grey,
                  height: 1.5.h,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (sessionApp.user != null)
                Text(
                  sessionApp.user!.username,
                  style: TextStyle(
                    color: AppColors.appBackgroud,
                    fontSize: 12.sp,
                    height: 1.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class DashboardMenuBottomWidgets extends StatelessWidget {
  const DashboardMenuBottomWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        menuAction(
          icon: AppAssetsSvg.user,
          title: 'Мой аккаунт',
          description: 'Информация об аккаунте',
          onTap: () async {
            await context.pushNamed(AppRouteConstant.account);
          },
        ),
        menuAction(
          icon: AppAssetsSvg.doc,
          title: 'Конфиденциальность',
          description: 'Обработка персональных данных',
          onTap: () => context.pushNamed(AppRouteConstant.politics),
        ),

        menuAction(
          icon: AppAssetsSvg.help,
          title: 'Поддержка',
          description: 'Сообщить о проблеме',
          onTap: () => context.pushNamed(AppRouteConstant.support),
        ),
        menuAction(
          icon: AppAssetsSvg.info,
          title: 'О приложении',
          description: 'Версия и информация',
          onTap: () => context.pushNamed(AppRouteConstant.infoApp),
        ),
        menuAction(
          icon: AppAssetsSvg.logout,
          title: 'Выйти из системы',
          description: 'И завершить сессию',
          onTap: () => sessionApp.logoutSession(
            firebaseRemoveFCM: FirebaseMessaging.instance.deleteToken
          ),
        ),
      ],
    );
  }

  Padding menuAction({
    required String title,
    required String description,
    required String icon,
    void Function()? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(height: 20.h, width: 20.h, icon),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appBackgroud,
                      height: 1.5.h,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.appBackgroud,
              size: 12.h,
            ),
          ],
        ),
      ),
    );
  }
}
