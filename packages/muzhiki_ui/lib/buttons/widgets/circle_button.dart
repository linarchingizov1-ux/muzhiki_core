import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muzhiki_ui/buttons/shared/button_tap.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.onPressed,
    required this.iconAsset,
    this.backgroundColor = MuzhikiColors.alertTextGrey,
    this.size = 42,
    this.iconSize = 40,
    this.disabled = false,
  });

  final VoidCallback onPressed;
  final String iconAsset;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final enabled = !disabled;
    final bg = buttonBackgroundColor(backgroundColor, enabled: enabled);

    return ButtonTap(
      onPressed: onPressed,
      enabled: enabled,
      child: Container(
        width: size.h,
        height: size.h,
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
        child: SvgPicture.asset(
          iconAsset,
          height: iconSize.h,
          width: iconSize.h,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
