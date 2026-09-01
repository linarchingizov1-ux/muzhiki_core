import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muzhiki_bridge/mp_bridge_view.dart';
import 'package:muzhiki_dependencies/service/session/session.dart';
import 'package:muzhiki_support/config/support_assets.dart';
import 'package:muzhiki_ui/muzhiki_ui.dart';

class InformatorView extends StatelessWidget {
  final String initialUrl;
  final SessionApp session;
  final String versin, buildV;
  const InformatorView({
    super.key,
    required this.initialUrl,
    required this.session,
    required this.versin,
    required this.buildV,
  });

  @override
  Widget build(BuildContext context) {
    MuzhikiColors.depend(context);
    return Scaffold(
      backgroundColor: MuzhikiColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 70,
        leading: Center(
          child: MuzhikiUi.buttons.back(
            backgroundColor: MuzhikiColors.isDark
                ? MuzhikiColors.surface
                : MuzhikiColors.grey,
            svgAsset: SupportAssets.I.svg.arrowBack,
            onTap: context.pop,
          ),
        ),
        title: const Text('Информатор'),
      ),
      body: MpBridgeWebView(
        showAppBar: false,
        initialUrl: initialUrl,
        build: buildV,
        version: versin,
        session: session,
      ),
    );
  }
}
