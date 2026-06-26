import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';
import 'package:mp_master_app/src/core/config/constants/app_route_constant.dart';
import 'package:mp_master_app/src/core/utils/extension/badge_priority_extension.dart';
import 'package:mp_master_app/src/core/utils/extension/color_extension.dart';
import 'package:mp_master_app/src/core/utils/extension/time_extension.dart';
import 'package:mp_master_app/src/data/model/records/badge.dart';
import 'package:mp_master_app/src/data/model/records/recordes.dart';
import 'package:mp_master_app/src/features/widgets/effect/skelet.dart';

class RecordsWidgets extends StatelessWidget {
  final bool showBadge;
  final RecordesModel recordesModel;
  final bool ready;
  final RecordBadgeMode badgeMode;

  const RecordsWidgets({
    this.showBadge = true,
    super.key,
    this.ready = true,
    required this.recordesModel,
    required this.badgeMode,
  });

  bool get isFine =>
      recordesModel.status == RecordesStatus.completed ||
      recordesModel.status == RecordesStatus.noShow ||
      recordesModel.status == RecordesStatus.cancelled;

  List<BadgeModel> get badges {
    final takeBadgesInMode = recordesModel.badges.selectByMode(badgeMode);
    return takeBadgesInMode;
  }

  @override
  Widget build(BuildContext context) {
    return AppSkelet(
      enable: !ready,
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRouteConstant.selectRecorde,
          extra: recordesModel.id,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.h,
            children: [
              Row(
                spacing: 14.w,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.r),
                      color: AppColors.light,
                    ),
                    child: Center(
                      child: Text(
                        recordesModel.datetime != null
                            ? recordesModel.datetime!.getHoursAndMinutes
                            : '00:00',
                        style: TextStyle(
                          color: isFine
                              ? const Color.fromARGB(74, 17, 17, 17)
                              : null,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text.rich(
                      softWrap: true,
                      TextSpan(
                        text: '${recordesModel.client?.name ?? 'Нет имени'}\n',
                        style: TextStyle(
                          height: 1.2,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text:
                                recordesModel.services != null &&
                                    recordesModel.services!.isNotEmpty
                                ? recordesModel.services!.first.name
                                : recordesModel.status == RecordesStatus.noShow
                                ? 'Клиент не пришел'
                                : '...',
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color:
                                  recordesModel.status == RecordesStatus.noShow
                                  ? AppColors.blood
                                  : AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    textAlign: TextAlign.end,
                    '>',
                    style: TextStyle(
                      height: 0.5.h,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (badges.isNotEmpty && showBadge)
                Row(
                  children: List.generate(badges.length, (index) {
                    final data = badges[index];
                    return Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 0 ? 5.w : 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 8.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(34.r),
                            color: data.color != null
                                ? data.color!.toColor
                                : AppColors.grey,
                          ),
                          child: Center(
                            child: Text(
                              data.label ?? '',
                              style: TextStyle(
                                fontSize: 12.sp,
                                height: 0.5.h,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ).animate().fade(),
            ],
          ),
        ),
      ),
    );
  }
}
