import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:talker/talker.dart';

class MuzhikiUrlLaunch {
  const MuzhikiUrlLaunch._();
  static final I = const MuzhikiUrlLaunch._();
  Future<void> openURL({
    required String url,
    String? path,
    Map<String, dynamic>? queryParameters,
    bool throwError = true,
  }) async {
    try {
      final parseURL = Uri.https(url, path ?? "", queryParameters);
      await launchUrl(
        parseURL,
        customTabsOptions: CustomTabsOptions(
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: false,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e, st) {
      Talker().error("Ошибка открытия ссылки: $e");
      if (throwError) {
        throw AppErrorMapper.I.map(e, st);
      } else {
        final error = AppErrorMapper.I.map(e, st);
        BannerController.I.show(message: error.message);
      }
    }
  }
}
