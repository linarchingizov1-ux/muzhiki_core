// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mp_master_app/src/core/config/color/app_colors.dart';
// import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';
// import 'package:mp_master_app/src/core/config/constants/app_route_constant.dart';

// class SliverInformator extends StatelessWidget {
//   const SliverInformator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SliverPadding(
//       padding: EdgeInsetsGeometry.only(left: 17.w, right: 17.w, bottom: 20.h),
//       sliver: SliverToBoxAdapter(
//         child: InkWell(
//           onTap: () {
//             context.pushNamed(AppRouteConstant.informator);
//           },
//           child: Container(
//             padding: EdgeInsets.all(12.r),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(21.r),
//               color: AppColors.black17,
//               image: DecorationImage(
//                 alignment: AlignmentGeometry.centerRight,
//                 image: AssetImage(AppAssetsPng.informatorBackground),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Информатор',
//                   style: TextStyle(
//                     color: AppColors.white,
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   'Аудиты и детализация по СМС',
//                   style: TextStyle(
//                     color: AppColors.white,
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
