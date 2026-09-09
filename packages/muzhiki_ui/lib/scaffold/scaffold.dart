import 'package:flutter/material.dart';
import 'package:muzhiki_ui/scaffold/widgets/scaffold_edge.dart';
import 'package:muzhiki_ui/theme/muzhiki_colors.dart';

export 'widgets/scaffold_edge.dart';

final class MuzhikiScaffold {
  const MuzhikiScaffold();

  Widget softEdge({
    Key? key,
    required Widget Function(
      BuildContext context,
      SoftEdgeScaffoldMetrics metrics,
    ) bodyBuilder,
    String? title,
    Widget? titleWidget,
    VoidCallback? onBack,
    bool backEnabled = true,
    Color? backIconColor,
    Widget? leading,
    Widget? trailing,
    Widget? bottomBar,
    EdgeInsetsGeometry? bottomBarPadding,
    Color backgroundColor = MuzhikiColors.appBackgroud,
    Color? tintColor,
    bool topBlur = true,
    bool bottomBlur = true,
    double? topBlurSize,
    double? bottomBlurSize,
    double? sigma,
    String? svgAssets,
    double? headerTopPadding,
    double? headerBottomPadding,
    bool enable = true,
    EdgeInsetsGeometry? headerHorizontalPadding,
    bool resizeToAvoidBottomInset = false,
    bool enableBackdropFilter = false,
  }) {
    return SoftEdgeScaffold(
      key: key,
      bodyBuilder: bodyBuilder,
      title: title,
      titleWidget: titleWidget,
      onBack: onBack,
      backEnabled: backEnabled,
      backIconColor: backIconColor,
      leading: leading,
      trailing: trailing,
      bottomBar: bottomBar,
      bottomBarPadding: bottomBarPadding,
      backgroundColor: backgroundColor,
      tintColor: tintColor,
      topBlur: topBlur,
      bottomBlur: bottomBlur,
      topBlurSize: topBlurSize,
      bottomBlurSize: bottomBlurSize,
      sigma: sigma,
      svgAssets: svgAssets,
      headerTopPadding: headerTopPadding,
      headerBottomPadding: headerBottomPadding,
      enable: enable,
      headerHorizontalPadding: headerHorizontalPadding,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      enableBackdropFilter: enableBackdropFilter,
    );
  }
}
