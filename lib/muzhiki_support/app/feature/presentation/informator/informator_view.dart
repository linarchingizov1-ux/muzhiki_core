import 'package:flutter/material.dart';
import 'package:muzhiki_core/muzhiki_bridge/data/repository/bridge_auth_repository.dart';
import 'package:muzhiki_core/muzhiki_bridge/domain/usecase/bridge_auth_usecase.dart';
import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:muzhiki_core/muzhiki_support/app/config/constant/support_colors.dart';

class InformatorView extends StatefulWidget {
  final String initialUrl;
  final SessionApp session;
  final String versin, build;
  const InformatorView({
    super.key,
    required this.initialUrl,
    required this.session,
    required this.versin,
    required this.build,
  });

  @override
  State<InformatorView> createState() => _InformatorViewState();
}

class _InformatorViewState extends State<InformatorView> {
  late BridgeAuthUsecase bridgeAuthUsecase;

  @override
  void initState() {
    bridgeAuthUsecase = BridgeAuthUsecase(
      repository: BridgeAuthRepositoryImpl(widget.session),
    );
    bridgeAuthUsecase.seedSession();
    super.initState();
  }

  @override
  void dispose() {
    bridgeAuthUsecase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SupportColors.white,
      appBar: AppBar(title: const Text('Информатор')),
      body: MpBridgeWebView(
        showAppBar: false,
        initialUrl: widget.initialUrl,
        build: widget.build,
        version: widget.versin,
        session: widget.session,
      ),
    );
  }
}
