import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';

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
      Uri parseURL;

      if (url.startsWith('http://') || url.startsWith('https://')) {
        final baseUri = Uri.parse(url);
        parseURL = baseUri.replace(
          path: path != null ? '${baseUri.path}$path' : null,
          queryParameters: queryParameters != null
              ? {...baseUri.queryParameters, ...queryParameters}
              : null,
        );
      } else {
        parseURL = Uri.https(url, path ?? "", queryParameters);
      }
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
          modalPresentationStyle:
              ViewControllerModalPresentationStyle.pageSheet,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e, st) {
      if (throwError) {
        throw AppErrorMapper.I.map(e, st);
      } else {
        final error = AppErrorMapper.I.map(e, st);
        BannerController.I.showError(error: error, message: error.message);
      }
    }
  }

  Future<void> close() async {
    try {
      await closeCustomTabs();
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);
      BannerController.I.showError(error: error, message: error.message);
    }
  }
}
