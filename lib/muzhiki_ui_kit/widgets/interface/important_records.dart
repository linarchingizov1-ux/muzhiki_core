import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp_master_app/src/core/utils/extension/badge_priority_extension.dart';
import 'package:mp_master_app/src/data/model/records/recordes.dart';
import 'package:mp_master_app/src/features/widgets/interface/records.dart';

class ImportantRecordsWidgets extends StatefulWidget {
  final List<RecordesModel> importantRecordsList;
  final bool isReady;
  final RecordBadgeMode badgeMode;

  const ImportantRecordsWidgets({
    super.key,
    this.importantRecordsList = const [],
    this.isReady = true,
    this.badgeMode = RecordBadgeMode.maxTwoHighest,
  });

  @override
  State<ImportantRecordsWidgets> createState() =>
      _ImportantRecordsWidgetsState();
}

class _ImportantRecordsWidgetsState extends State<ImportantRecordsWidgets> {
  late PageController pageController;
  bool? showBadge;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.9);
    animatedSize(0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  late double heightimportantRecordsList;
  bool needReSizeForCurrentPage(int page) {
    if (page >= 0 && page < widget.importantRecordsList.length) {
      final currentRecord = widget.importantRecordsList[page];
      return currentRecord.badges.selectByMode(widget.badgeMode).isNotEmpty;
    }

    return false;
  }

  void animatedSize(int page) async {
    final needR = needReSizeForCurrentPage(page);
    showBadge = needR;
    if (needR) {
      setState(() {
        heightimportantRecordsList = 90.h;
      });
    } else {
      setState(() {
        heightimportantRecordsList = 62.h;
      });
    }
  }

  EdgeInsets paddingImportant({required int index}) {
    final length = widget.importantRecordsList.length;
    if (length == 1) return EdgeInsets.zero;

    final isFirst = index == 0;
    final isLast = index == length - 1;

    return EdgeInsets.only(
      left: isFirst ? 17.w : 2.5.w,
      right: isLast ? 17.w : 2.5.w,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: SizedBox(
              height: heightimportantRecordsList,
              child: PageView.builder(
                padEnds: widget.importantRecordsList.length > 1 ? false : true,
                itemCount: widget.importantRecordsList.length,
                controller: pageController,
                onPageChanged: (value) => animatedSize(value),
                itemBuilder: (context, index) {
                  final records = widget.importantRecordsList[index];
                  return Padding(
                    padding: paddingImportant(index: index),
                    child: RecordsWidgets(
                      showBadge: showBadge ?? false,
                      badgeMode: widget.badgeMode,
                      recordesModel: records,
                      ready: widget.isReady,
                    ),
                  );
                },
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 220.ms)
        .scaleXY(
          begin: 0.94,
          end: 1,
          curve: Curves.easeOutBack,
          duration: 320.ms,
        )
        .moveY(begin: 10, end: 0, duration: 320.ms, curve: Curves.easeOut);
  }
}
