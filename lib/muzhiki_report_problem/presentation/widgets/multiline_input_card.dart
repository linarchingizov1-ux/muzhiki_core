import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muzhiki_core/muzhiki_report_problem/config/report_problem_colors.dart';

class MultilineInputCard extends StatefulWidget {
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
  State<MultilineInputCard> createState() => _MultilineInputCardState();
}

class _MultilineInputCardState extends State<MultilineInputCard> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
      child: Container(
        constraints: BoxConstraints(
          minHeight: widget.minHeight.h,
          maxHeight: widget.maxHeight.h,
        ),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: ReportProblemColors.white,
          borderRadius: BorderRadius.circular(21.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              minLines: 1,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: ReportProblemColors.black23,
                height: 1.3,
              ),
              decoration: InputDecoration(
                isDense: true,
                counterText: '',
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: ReportProblemColors.greyText,
                  height: 1.3,
                ),
              ),
            ),
            if (widget.footer != null) ...[
              SizedBox(height: 12.h),
              widget.footer!,
            ],
          ],
        ),
      ),
    );
  }
}
