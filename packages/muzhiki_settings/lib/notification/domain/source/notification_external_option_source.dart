import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_option_entity.dart';

class NotificationExternalOptionSource {
  final bool isMultiple;
  final Future<List<NotificationParameterOptionEntity>> Function()
  getParameterOptions;

  const NotificationExternalOptionSource({
    required this.getParameterOptions,
    this.isMultiple = false,
  });
}
