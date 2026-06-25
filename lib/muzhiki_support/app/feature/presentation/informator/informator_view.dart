// import 'package:flutter/material.dart';
// import 'package:mp_master_app/src/core/config/color/app_colors.dart';
// import 'package:mp_master_app/src/data/repository/bridge_auth_repository.dart';
// import 'package:mp_master_app/src/domain/usecase/bridge_auth_usecase.dart';
// import 'package:mp_master_app/src/features/widgets/interface/mp_bridge_view.dart';

// class InformatorView extends StatefulWidget {
//   final String initialUrl;
//   const InformatorView({super.key, required this.initialUrl});

//   @override
//   State<InformatorView> createState() => _InformatorViewState();
// }

// class _InformatorViewState extends State<InformatorView> {
//   late BridgeAuthUsecase bridgeAuthUsecase;

//   @override
//   void initState() {
//     bridgeAuthUsecase = BridgeAuthUsecase(BridgeAuthRepositoryImpl());
//     bridgeAuthUsecase.seedSession();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     bridgeAuthUsecase.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(title: const Text('Информатор')),
//       body: MpBridgeWebView(
//         initialUrl: widget.initialUrl,
//         authRepository: bridgeAuthUsecase,
//       ),
//     );
//   }
// }
