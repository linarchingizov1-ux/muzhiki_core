import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';
import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';
import 'package:mp_master_app/src/core/dependencies/app_dependencies.dart';
import 'package:mp_master_app/src/core/websocket/model/socket_connection.dart';
import 'package:mp_master_app/src/features/main/view_support/state/attachments/attachments_cubit.dart';
import 'package:mp_master_app/src/features/widgets/interface/app_support/upload_data_widgets.dart';

class TextFieldWidgets extends StatefulWidget {
  final void Function() send;
  final TextEditingController controller;

  const TextFieldWidgets({
    super.key,
    required this.controller,
    required this.send,
  });

  @override
  State<TextFieldWidgets> createState() => _TextFieldWidgetsState();
}

class _TextFieldWidgetsState extends State<TextFieldWidgets> {
  bool get _hasText => widget.controller.text.trim().isNotEmpty;

  bool get _hasAttachments =>
      context.watch<AttachmentsCubit>().state.items.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentsCubit, AttachmentsState>(
      builder: (context, state) {
        return Row(
          spacing: 8.w,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _CircleMenuAnimated(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.items.isNotEmpty)
                    SizedBox(
                      height: 65.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => SizedBox(width: 8.w),
                        itemBuilder: (context, i) {
                          return UploadDataWidgets(item: state.items[i]);
                        },
                      ),
                    ),
                  SizedBox(height: 6.h),
                  Stack(
                    children: [
                      TextField(
                        controller: widget.controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        minLines: 1,
                        expands: false,
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Сообщение...',
                          hintStyle: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.grey,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                            left: 12.w,
                            right: 50.w,
                            top: 12.h,
                            bottom: 12.h,
                          ),
                          filled: true,
                          fillColor: AppColors.light,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4.w,
                        bottom: 4.w,
                        child: GestureDetector(
                          onTap: widget.send,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 30.w,
                            width: 45.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: _hasText || _hasAttachments
                                  ? AppColors.blood
                                  : AppColors.grey,
                            ),
                            child: Icon(
                              Icons.send,
                              size: 16.r,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CircleMenuAnimated extends StatefulWidget {
  const _CircleMenuAnimated();

  @override
  State<_CircleMenuAnimated> createState() => _CircleMenuAnimatedState();
}

class _CircleMenuAnimatedState extends State<_CircleMenuAnimated>
    with SingleTickerProviderStateMixin {
  late final OverlayPortalController overlayPortalController;
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<Offset> slideAnimation;
  List<PlatformFile> files = [];

  bool isOpen = false;
  bool isDisopse = false;

  FocusNode? get focus => WidgetsBinding.instance.focusManager.primaryFocus;

  @override
  void initState() {
    super.initState();
    overlayPortalController = OverlayPortalController();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 50),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
            reverseCurve: Curves.easeInCubic,
          ),
        );
  }

  @override
  void dispose() {
    isDisopse = true;
    animationController.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    if (isOpen || isDisopse) return;
    if (focus?.hasFocus ?? false) {
      focus?.unfocus();
      await Future.delayed(const Duration(milliseconds: 250));
    }
    overlayPortalController.show();
    setState(() => isOpen = true);
    await animationController.forward();
  }

  Future<void> _close() async {
    if (!isOpen || animationController.isDismissed) return;

    await animationController.reverse();
    overlayPortalController.hide();

    if (mounted) {
      setState(() => isOpen = false);
    }
  }

  Future<void> _toggle() async {
    if (isOpen) {
      await _close();
    } else {
      await _open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AttachmentsCubit>(),
      child: BlocBuilder<AttachmentsCubit, AttachmentsState>(
        builder: (context, state) {
          return OverlayPortal(
            controller: overlayPortalController,
            overlayChildBuilder: (context) {
              return Positioned.fill(
                child: SafeArea(
                  child: Stack(
                    children: [
                      FadeTransition(
                        opacity: fadeAnimation,
                        child: InkWell(
                          onTap: _close,
                          child: const SizedBox.expand(),
                        ),
                      ),
                      Positioned(
                        bottom: 70.h + MediaQuery.paddingOf(context).bottom,
                        left: 17.w,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: ScaleTransition(
                              scale: scaleAnimation,
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10.h,
                                children: [
                                  _OverlayIconBuild(
                                    asset: AppAssetsSvg.image,
                                    onTap: () async {
                                      await context
                                          .read<AttachmentsCubit>()
                                          .addAttachment(
                                            type: ChatAttachmentType.photo,
                                          );
                                      _close();
                                    },
                                  ),
                                  _OverlayIconBuild(
                                    asset: AppAssetsSvg.recodeVideo,
                                    onTap: () async {
                                      await context
                                          .read<AttachmentsCubit>()
                                          .addAttachment(
                                            type: ChatAttachmentType.video,
                                          );
                                      _close();
                                    },
                                  ),
                                  _OverlayIconBuild(
                                    asset: AppAssetsSvg.file,
                                    onTap: () async {
                                      await context
                                          .read<AttachmentsCubit>()
                                          .addAttachment(
                                            type: ChatAttachmentType.document,
                                          );
                                      _close();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: _OverlayIconBuild(
              iconColor: isOpen ? AppColors.blood : AppColors.white,
              color: isOpen ? AppColors.white : AppColors.blood,
              onTap: _toggle,
              asset: isOpen ? AppAssetsSvg.close : AppAssetsSvg.screpka,
            ),
          );
        },
      ),
    );
  }
}

class _OverlayIconBuild extends StatelessWidget {
  final VoidCallback onTap;
  final String asset;
  final Color? color;
  final Color? iconColor;

  const _OverlayIconBuild({
    required this.onTap,
    required this.asset,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      height: 45.w,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? AppColors.white,
          ),
          child: Center(
            child: SizedBox(
              width: 15.r,
              height: 15.r,
              child: SvgPicture.asset(
                asset,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  iconColor ?? AppColors.blood,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
