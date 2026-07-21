import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/ui/config/network_problem_assets.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/ui/config/network_problem_colors.dart';
import 'package:muzhiki_core/muzhiki_report_problem/presentation/widgets/button_small.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/button.dart';

enum _NetworkIssuePage { main, whatToDo, whatWeDo }

class NetworkIssueDialog extends StatefulWidget {
  const NetworkIssueDialog({super.key});

  @override
  State<NetworkIssueDialog> createState() => _NetworkIssueDialogState();
}

class _NetworkIssueDialogState extends State<NetworkIssueDialog> {
  _NetworkIssuePage _page = _NetworkIssuePage.main;

  static const _whatToDoText =
      'Попробуйте изменить подключение к сети: подключитесь другим способом, '
      'через WiFi или наоборот через мобильную сеть. Попробуйте отключить VPN '
      'или наоборот подключить его.\n\n'
      'Нам очень жаль, что вы столкнулись с проблемой. Если вы считаете, что '
      'проблема не с сетью, потрясите устройство, чтобы отправить информацию '
      'разработчикам.';

  static const _whatWeDoText =
      'Для локализации и контроля над проблемой мы замеряем время, за которое '
      'наши пользователи получают ответ от сервера и видим большую часть '
      'задержек.\n\n'
      'Мы проводим миграцию на сервера крупных компаний — со временем это '
      'должно стабилизировать ситуацию с сетью.';

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_page == _NetworkIssuePage.main) ...[
            Center(
              child: SvgPicture.asset(
                NetworkProblemAssets.networkSVG,
                width: 124.r,
                height: 124.r,
                colorFilter: const ColorFilter.mode(
                  NetworkProblemColors.greyText,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 21.h),
            Text.rich(
              const TextSpan(
                text: 'Не во всех странах сеть работает стабильно',
                children: [
                  TextSpan(
                    text: ', такие времена',
                    style: TextStyle(color: NetworkProblemColors.greyText),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: NetworkProblemColors.black23,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Видим, что приложение зависает из-за проблем с сетью. '
              'Это не связано с ошибками в коде или качеством разработки.',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 1.3,
                color: NetworkProblemColors.alertTextGrey,
              ),
            ),
            SizedBox(height: 27.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NetworkIssueButton(
                  label: 'И что делать?',
                  onTap: () =>
                      setState(() => _page = _NetworkIssuePage.whatToDo),
                ),
                SizedBox(height: 9.h),
                _NetworkIssueButton(
                  label: 'Что мы делаем, чтобы стало лучше',
                  onTap: () =>
                      setState(() => _page = _NetworkIssuePage.whatWeDo),
                ),
              ],
            ),
          ] else ...[
            Align(
              alignment: Alignment.centerLeft,
              child: _NetworkIssueButton(
                label: 'Назад',
                onTap: () => setState(() => _page = _NetworkIssuePage.main),
              ),
            ),
            SizedBox(height: 27.h),
            Text(
              _page == _NetworkIssuePage.whatToDo
                  ? _whatToDoText
                  : _whatWeDoText,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: NetworkProblemColors.alertTextGrey,
              ),
            ),
          ],
          SizedBox(height: 27.h),
          AppButton(
            mode: ButtonMode.classic,
            label: 'Ох, ладно',
            backgroundColor: NetworkProblemColors.greyLight,
            labelColor: NetworkProblemColors.black23,
            borderRadius: 20,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _NetworkIssueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NetworkIssueButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppButtonSmall(
      mode: SmallButtonMode.standart,
      label: label,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      labelColor: NetworkProblemColors.alertTextGrey,
      backgroundColor: NetworkProblemColors.greyLight.withValues(alpha: 0.3),
      labelPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
      onTap: onTap,
    );
  }
}
