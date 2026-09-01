import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class SettingsSwitch extends StatelessWidget {
  final Function() onTap;
  final bool value;
  final bool enabled;
  final Color? disableSwitchColor;

  const SettingsSwitch({
    super.key,
    required this.onTap,
    required this.value,
    this.enabled = true,
    this.disableSwitchColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        width: 44.w,
        height: 25.h,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: value ? MuzhikiColors.blood : MuzhikiColors.greyLight,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 100),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  width: 20.h,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value
                        ? MuzhikiColors.greyLight
                        : disableSwitchColor ?? MuzhikiColors.blood,
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
