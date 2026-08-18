import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_parameter_option.dart';

class NotificationSettingsState {
  final List<NotificationSubscriptionModel>? subscriptions;
  final Map<String, List<NotificationParameterOption>> externalOptionsByType;
  final String? selectedNotificationKey;
  final bool isSubscriptionsLoading;
  final Set<String> loadingExternalOptionsTypes;
  final Map<String, String> externalOptionsErrorsByType;
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

  NotificationSubscriptionModel? get selectedSubscription => subscriptions
      ?.where((item) => item.notificationKey == selectedNotificationKey)
      .firstOrNull;

  NotificationSettingsState copyWith({
    List<NotificationSubscriptionModel>? subscriptions,
    Map<String, List<NotificationParameterOption>>? externalOptionsByType,
    String? selectedNotificationKey,
    bool? isSubscriptionsLoading,
    Set<String>? loadingExternalOptionsTypes,
    Map<String, String>? externalOptionsErrorsByType,
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
