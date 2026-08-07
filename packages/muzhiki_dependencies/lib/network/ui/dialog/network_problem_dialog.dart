import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_dependencies/network/ui/config/network_problem_assets.dart';
import 'package:muzhiki_dependencies/network/ui/config/network_problem_colors.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

enum _NetworkIssuePage { main, whatToDo, whatWeDo }

class NetworkIssueDialog extends StatefulWidget {
  const NetworkIssueDialog({super.key});

  @override
  State<NetworkIssueDialog> createState() => _NetworkIssueDialogState();
}

class _NetworkIssueDialogState extends State<NetworkIssueDialog> {
  _NetworkIssuePage _page = _NetworkIssuePage.main;

  static const _whatToDoText =
      '���������� �������� ����������� � ����: ������������ ������ ��������, '
      '����� WiFi ��� �������� ����� ��������� ����. ���������� ��������� VPN '
      '��� �������� ���������� ���.\n\n'
      '��� ����� ����, ��� �� ����������� � ���������. ���� �� ��������, ��� '
      '�������� �� � �����, ��������� ����������, ����� ��������� ���������� '
      '�������������.';

  static const _whatWeDoText =
      '��� ����������� � �������� ��� ��������� �� �������� �����, �� ������� '
      '���� ������������ �������� ����� �� ������� � ����� ������� ����� '
      '��������.\n\n'
      '�� �������� �������� �� ������� ������� �������� � �� �������� ��� '
      '������ ��������������� �������� � �����.';

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
                text: '�� �� ���� ������� ���� �������� ���������',
                children: [
                  TextSpan(
                    text: ', ����� �������',
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
              '�����, ��� ���������� �������� ��-�� ������� � �����. '
              '��� �� ������� � �������� � ���� ��� ��������� ����������.',
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
                  label: '� ��� ������?',
                  onTap: () =>
                      setState(() => _page = _NetworkIssuePage.whatToDo),
                ),
                SizedBox(height: 9.h),
                _NetworkIssueButton(
                  label: '��� �� ������, ����� ����� �����',
                  onTap: () =>
                      setState(() => _page = _NetworkIssuePage.whatWeDo),
                ),
              ],
            ),
          ] else ...[
            Align(
              alignment: Alignment.centerLeft,
              child: _NetworkIssueButton(
                label: '�����',
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
          MuzhikiUi.buttons.primary(
            label: '��, �����',
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
    return MuzhikiUi.buttons.small(
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
