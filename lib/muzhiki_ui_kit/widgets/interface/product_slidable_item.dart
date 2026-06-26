import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp_master_app/src/core/config/color/app_colors.dart';
import 'package:mp_master_app/src/core/config/constants/app_assets_constant.dart';
import 'package:mp_master_app/src/data/model/product/saled_product.dart';
import 'package:mp_master_app/src/features/widgets/effect/skelet.dart';

class ProductSlidableItem extends StatefulWidget {
  final SaledProductModel product;
  final bool isReady;
  final bool hideRemove;
  final VoidCallback onDelete;

  const ProductSlidableItem({
    this.hideRemove = false,
    super.key,
    required this.product,
    required this.isReady,
    required this.onDelete,
  });

  @override
  State<ProductSlidableItem> createState() => _ProductSlidableItemState();
}

class _ProductSlidableItemState extends State<ProductSlidableItem>
    with SingleTickerProviderStateMixin {
  late final SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    slidableController = SlidableController(this);
  }

  @override
  void dispose() {
    slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSkelet(
      enable: !widget.isReady,
      child: Slidable(
        enabled: !widget.hideRemove,
        key: ValueKey(widget.product.productId),
        controller: slidableController,
        endActionPane: ActionPane(
          extentRatio: 0.18,
          motion: const ScrollMotion(),
          children: [
            CustomSlidableAction(
              onPressed: (_) {
                widget.onDelete.call();
              },
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(13.r),
                bottomRight: Radius.circular(13.r),
              ),
              child: SvgPicture.asset(
                AppAssetsSvg.remove,
                width: 20.w,
                height: 20.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        child: ValueListenableBuilder<double>(
          valueListenable: slidableController.animation,
          builder: (context, value, child) {
            final rightRadius = slidableController.ratio.abs() > 0 ? 0.0 : 13.r;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13.r),
                  bottomLeft: Radius.circular(13.r),
                  topRight: Radius.circular(rightRadius),
                  bottomRight: Radius.circular(rightRadius),
                ),
              ),
              child: child,
            );
          },
          child: Text.rich(
            TextSpan(
              text: widget.product.name.isNotEmpty
                  ? '${widget.product.name}\n'
                  : 'Отсутствует название товара\n',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                  text: '${widget.product.price} ₽',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
