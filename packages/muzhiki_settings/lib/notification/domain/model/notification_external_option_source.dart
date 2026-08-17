import 'package:muzhiki_settings/notification/domain/model/notification_parameter_option.dart';

class NotificationExternalOptionSource {
  final bool isMultiple;
  final Future<List<NotificationParameterOption>> Function()
  getParameterOptions;

  const NotificationExternalOptionSource({
    required this.getParameterOptions,
    this.isMultiple = false,
  });
}
