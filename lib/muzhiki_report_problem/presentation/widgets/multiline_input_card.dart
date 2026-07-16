import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_config/colors/core_colors.dart';
import 'package:muzhiki_core/muzhiki_config/fonts/core_fonts.dart';

class MultilineInputCard extends StatelessWidget {
  final TextEditingController controller;
  final double minHeight;
  final double maxHeight;
  final int maxLines;
  final int maxLength;
  final bool enabled;
  final String hintText;
  final Widget? footer;

  const MultilineInputCard({
    super.key,
    required this.controller,
    this.minHeight = 190,
    this.maxHeight = 400,
    this.maxLines = 10,
    this.maxLength = 5000,
    this.enabled = true,
    required this.hintText,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: minHeight.h,
        maxHeight: maxHeight.h,
      ),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: CoreColors.white,
        borderRadius: BorderRadius.circular(21.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            enabled: enabled,
            minLines: 1,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: CoreFonts.medium,
              color: CoreColors.black23,
              height: 1.3,
            ),
            decoration: InputDecoration(
              isDense: true,
              counterText: '',
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 15.sp,
                fontWeight: CoreFonts.medium,
                color: CoreColors.greyText,
                height: 1.3,
              ),
            ),
          ),
          if (footer != null) ...[SizedBox(height: 12.h), footer!],
        ],
      ),
    );
  }
}
