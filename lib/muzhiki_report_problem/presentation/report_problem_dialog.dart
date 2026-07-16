import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muzhiki_core/muzhiki_config/colors/core_colors.dart';
import 'package:muzhiki_core/muzhiki_config/fonts/core_fonts.dart';
import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:muzhiki_core/muzhiki_report_problem/config/report_problem_assets.dart';
import 'package:muzhiki_core/muzhiki_report_problem/config/report_problem_config.dart';
import 'package:muzhiki_core/muzhiki_report_problem/data/repository/bug_report_repository_impl.dart';
import 'package:muzhiki_core/muzhiki_report_problem/presentation/view_model/report_problem_view_model.dart';
import 'package:muzhiki_core/muzhiki_report_problem/presentation/widgets/button_small.dart';
import 'package:muzhiki_core/muzhiki_report_problem/presentation/widgets/error_dialog.dart';
import 'package:muzhiki_core/muzhiki_report_problem/presentation/widgets/multiline_input_card.dart';
import 'package:muzhiki_core/muzhiki_report_problem/presentation/widgets/success_dialog.dart';
import 'package:muzhiki_core/muzhiki_support/app/data/model/view_image_item_model.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/app_dialog.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/button.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/photo_view_widget.dart';
import 'package:provider/provider.dart';

class ReportProblemDialog extends StatefulWidget {
  final ReportProblemConfig config;

  const ReportProblemDialog({super.key, required this.config});

  @override
  State<ReportProblemDialog> createState() => _ReportProblemDialogState();
}

class _ReportProblemDialogState extends State<ReportProblemDialog> {
  late final ReportProblemViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ReportProblemViewModel(
      config: widget.config,
      repository: BugReportRepositoryImpl(widget.config.dio),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await viewModel.submit();
    if (!mounted) return;
    if (viewModel.isSubmitSuccess == true) {
      await AppDialog.standart(
        backgroundColor: CoreColors.appBackgroud,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22.r),
          bottom: Radius.circular(
            MuzhikiDependencies.I.divesRadius?.bottomLeft ?? 32.r,
          ),
        ),
        outerPadding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
        child: const SuccessDialog(title: 'Форма отправлена'),
      );
      await Future.delayed(500.ms);
      if (!mounted) return;
      context.pop();
    } else {
      await AppDialog.standart(
        backgroundColor: CoreColors.appBackgroud,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22.r),
          bottom: Radius.circular(
            MuzhikiDependencies.I.divesRadius?.bottomLeft ?? 32.r,
          ),
        ),
        outerPadding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
        child: ErrorDialog(
          title: 'Не удалось отправить форму',
          description:
              viewModel.submitError ??
              'Что-то пошло не так, попробуйте ещё раз',
          onRetry: () => _submit(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Consumer<ReportProblemViewModel>(
          builder: (context, viewModel, child) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppButtonSmall(
                      mode: SmallButtonMode.standart,
                      label: 'Отменить',
                      fontSize: 15,
                      fontWeight: CoreFonts.medium,
                      labelColor: CoreColors.alertTextGrey,
                      backgroundColor: CoreColors.greyLight.withValues(
                        alpha: 0.3,
                      ),
                      labelPadding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 15.w,
                      ),
                      onTap: () => context.pop(),
                    ),
                  ),
                  SizedBox(height: 21.h),
                  Center(
                    child: SvgPicture.asset(
                      ReportProblemAssets.vibrateSVG,
                      width: 122.r,
                      height: 122.r,
                    ),
                  ),
                  SizedBox(height: 21.h),
                  Text(
                    'Сообщить о проблеме',
                    style: TextStyle(
                      fontSize: 18.sp,
                      height: 1.3,
                      fontWeight: CoreFonts.semiBold,
                      color: CoreColors.black23,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Это окно открылось потому что вы потрясли устройство',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: CoreFonts.medium,
                      height: 1.3,
                      color: CoreColors.alertTextGrey,
                    ),
                  ),
                  SizedBox(height: 27.h),
                  MultilineInputCard(
                    controller: viewModel.descriptionController,
                    minHeight: 190,
                    maxHeight: 400,
                    maxLines: 10,
                    maxLength: 5000,
                    enabled: !viewModel.isSubmitting,
                    hintText: 'Опишите проблему',
                    footer: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          AppButtonSmall(
                            mode: SmallButtonMode.icon,
                            alignment: AlignmentButtonIcon.start,
                            icon: SvgPicture.asset(
                              ReportProblemAssets.screpka,
                              width: 16.r,
                              height: 16.r,
                              colorFilter: const ColorFilter.mode(
                                CoreColors.blood,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: 'Добавить скриншот',
                            fontSize: 15,
                            fontWeight: CoreFonts.medium,
                            labelColor: CoreColors.alertTextGrey,
                            backgroundColor: CoreColors.appBackgroud,
                            radius: 20,
                            labelPadding: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 12.w,
                            ),
                            onTap: () async {
                              if (viewModel.isSubmitting) return;
                              final picked = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (picked == null) return;
                              await viewModel.setScreenshot(picked.path);
                            },
                          ),
                          if (viewModel.screenshotPath != null) ...[
                            SizedBox(height: 10.w),
                            SizedBox(
                              width: 90.w,
                              height: 90.h,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Hero(
                                      tag: viewModel.screenshotPath!,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          21.r,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                opaque: false,
                                                maintainState: true,
                                                transitionDuration:
                                                    const Duration(
                                                      milliseconds: 350,
                                                    ),
                                                reverseTransitionDuration:
                                                    const Duration(
                                                      milliseconds: 350,
                                                    ),
                                                transitionsBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child,
                                                    ) {
                                                      return FadeTransition(
                                                        opacity: CurvedAnimation(
                                                          parent: animation,
                                                          curve: Curves
                                                              .easeInOutCubic,
                                                        ),
                                                        child: child,
                                                      );
                                                    },
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) {
                                                      return PhotoViewerPage(
                                                        images: [
                                                          ViewerImageItem.filePath(
                                                            viewModel
                                                                .screenshotPath!,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                              ),
                                            );
                                          },
                                          child: Image.file(
                                            File(viewModel.screenshotPath!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 6.r,
                                    top: 6.r,
                                    child: InkWell(
                                      onTap: () =>
                                          viewModel.setScreenshot(null),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(6.r),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: CoreColors.black23.withValues(
                                            alpha: 0.65,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          ReportProblemAssets.close,
                                          width: 8.w,
                                          height: 8.h,
                                          colorFilter: const ColorFilter.mode(
                                            CoreColors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 27.h),
                  Text(
                    'Данные о вашем устройстве и действиях будут отправлены автоматически',
                    style: TextStyle(
                      fontSize: 15.sp,
                      height: 1.3,
                      fontWeight: CoreFonts.medium,
                      color: CoreColors.alertTextGrey,
                    ),
                  ),
                  SizedBox(height: 27.h),
                  AppButton(
                    mode: ButtonMode.classic,
                    label: viewModel.isSubmitSuccess == false
                        ? 'Повторить'
                        : 'Отправить',
                    isLoading: viewModel.isSubmitting,
                    backgroundColor: viewModel.isValid
                        ? CoreColors.black23
                        : CoreColors.light,
                    labelColor: viewModel.isValid
                        ? CoreColors.white
                        : CoreColors.black23,
                    borderRadius: 20,
                    onPressed: viewModel.isValid ? () => _submit() : () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
