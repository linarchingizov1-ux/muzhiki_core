import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_option_entity.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_parameter_type.dart';
import 'package:muzhiki_settings/notification/domain/entity/notification_subscription_entity.dart';

class NotificationSettingsState {
  final List<NotificationSubscriptionEntity>? subscriptions;
  final Map<NotificationParameterType, List<NotificationParameterOptionEntity>>
  externalOptionsByType;
  final String? selectedNotificationKey;
  final bool isSubscriptionsLoading;
  final Set<NotificationParameterType> loadingExternalOptionsTypes;
  final Map<NotificationParameterType, String> externalOptionsErrorsByType;
  final String? subscriptionsError;
  final String? lastDetailSavingError;

  const NotificationSettingsState({
    this.subscriptions,
    this.externalOptionsByType = const {},
    this.selectedNotificationKey,
    this.loadingExternalOptionsTypes = const {},
    this.isSubscriptionsLoading = true,
    this.externalOptionsErrorsByType = const {},
    this.subscriptionsError,
    this.lastDetailSavingError,
  });

  NotificationSubscriptionEntity? get selectedSubscription => subscriptions
      ?.where((item) => item.notificationKey == selectedNotificationKey)
      .firstOrNull;

  NotificationSettingsState copyWith({
    List<NotificationSubscriptionEntity>? subscriptions,
    Map<NotificationParameterType, List<NotificationParameterOptionEntity>>?
    externalOptionsByType,
    String? selectedNotificationKey,
    bool? isSubscriptionsLoading,
    Set<NotificationParameterType>? loadingExternalOptionsTypes,
    Map<NotificationParameterType, String>? externalOptionsErrorsByType,
    String? subscriptionsError,
    String? lastDetailSavingError,
    bool clearSubscriptionsError = false,
    bool clearLastDetailSavingError = false,
  }) {
    return NotificationSettingsState(
      subscriptions: subscriptions ?? this.subscriptions,
      externalOptionsByType:
          externalOptionsByType ?? this.externalOptionsByType,
      selectedNotificationKey:
          selectedNotificationKey ?? this.selectedNotificationKey,
      isSubscriptionsLoading:
          isSubscriptionsLoading ?? this.isSubscriptionsLoading,
      loadingExternalOptionsTypes:
          loadingExternalOptionsTypes ?? this.loadingExternalOptionsTypes,
      externalOptionsErrorsByType:
          externalOptionsErrorsByType ?? this.externalOptionsErrorsByType,
      subscriptionsError: clearSubscriptionsError
          ? null
          : subscriptionsError ?? this.subscriptionsError,
      lastDetailSavingError: clearLastDetailSavingError
          ? null
          : lastDetailSavingError ?? this.lastDetailSavingError,
    );
  }
}
