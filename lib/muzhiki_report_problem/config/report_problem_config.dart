import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/metrics/request_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_version/model/app_info_model.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
import 'package:talker/talker.dart';

class ReportProblemConfig {
  final SessionApp session;
  final Talker talker;
  final AppInfoModel appInfo;
  final RequestStorage requestStorage;
  final BannerController bannerController;
  final Dio dio;
  final String appName;
  final Map<String, dynamic> Function()? screenRoute;

  const ReportProblemConfig({
    required this.session,
    required this.talker,
    required this.appInfo,
    required this.requestStorage,
    required this.bannerController,
    required this.dio,
    required this.appName,
    this.screenRoute,
  });
}
