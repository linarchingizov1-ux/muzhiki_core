import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muzhiki_settings/notification/domain/source/notification_external_option_source.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_type.dart';

class NotificationSettingsModuleConfig {
  final Dio authDio;
  final Widget? vpnDetector;
  final Map<NotificationParameterType, NotificationExternalOptionSource>
  externalOptionSources;

  const NotificationSettingsModuleConfig({
    required this.authDio,
    this.vpnDetector,
    this.externalOptionSources = const {},
  });
}
