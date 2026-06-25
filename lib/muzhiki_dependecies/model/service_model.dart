import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/session.dart';
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
