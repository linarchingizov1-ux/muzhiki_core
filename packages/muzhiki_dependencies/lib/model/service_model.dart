import 'package:muzhiki_dependencies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_dependencies/service/session/session.dart';
import 'package:talker/talker.dart';

class ServiceModel {
  final BannerController bannerController;
  final Talker talker;
  final SessionApp session;
  ServiceModel({
    required this.session,
    required this.talker,
    required this.bannerController,
  });
}
