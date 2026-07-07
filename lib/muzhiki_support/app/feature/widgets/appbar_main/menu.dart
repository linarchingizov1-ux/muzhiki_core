import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_assets.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';

class SupportAppBarMenu extends StatelessWidget {
  final SessionApp sessionApp;
  const SupportAppBarMenu({super.key, required this.sessionApp});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Добро пожаловать!',
          style: TextStyle(
            color: SupportColors.grey,
            height: 1.5.h,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (sessionApp.user != null)
          Text(
            sessionApp.user!.username,
            style: TextStyle(
              color: SupportColors.appBackgroud,
              fontSize: 12.sp,
              height: 1.h,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class DashboardMenuBottomWidgets extends StatelessWidget {
  final SessionApp sessionApp;
  final void Function()? firebaseRemoveFCM;
  const DashboardMenuBottomWidgets({
    super.key,
    required this.sessionApp,
    this.firebaseRemoveFCM,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // menuAction(
        //   icon: SupportAssets.I.svg.,
        //   title: 'Мой аккаунт',
        //   description: 'Информация об аккаунте',
        //   onTap: () async {
        //     await context.pushNamed(AppRouteConstant.account);
        //   },
        // ),
        // menuAction(
        //   icon: AppAssetsSvg.doc,
        //   title: 'Конфиденциальность',
        //   description: 'Обработка персональных данных',
        //   onTap: () => getIt<DependenciesModel>().network.uriLauncer.openURL(
        //     throwError: false,
        //     url:
        //         'https://docs.google.com/document/d/1mY8UGldwY-kFACWI20FQnQ_Zoe1a_LDUYwB4OpzLa8o/mobilebasic',
        //   ),
        // ),

        // menuAction(
        //   icon: AppAssetsSvg.help,
        //   title: 'Поддержка',
        //   description: 'Сообщить о проблеме',
        //   onTap: () => context.pushNamed(SupportModule.routeConstant.support),
        // ),
        // menuAction(
        //   icon: AppAssetsSvg.info,
        //   title: 'О приложении',
        //   description: 'Версия и информация',
        //   onTap: () => context.pushNamed(AppRouteConstant.infoApp),
        // ),
        menuAction(
          icon: SupportAssets.I.svg.logout,
          title: 'Выйти из системы',
          description: 'И завершить сессию',
          onTap: () =>
              sessionApp.logoutSession(firebaseRemoveFCM: firebaseRemoveFCM),
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
                      color: SupportColors.appBackgroud,
                      height: 1.5.h,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: SupportColors.greyText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: SupportColors.appBackgroud,
              size: 12.h,
            ),
          ],
        ),
      ),
    );
  }
}
