import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_external_option_source.dart';

class NotificationSettingsModuleConfig {
  final Dio authDio;
  final Widget? vpnDetector;
  final Map<String, NotificationExternalOptionSource> externalOptionSources;

  const NotificationSettingsModuleConfig({
    required this.authDio,
    this.vpnDetector,
    this.externalOptionSources = const {},
  });
}
