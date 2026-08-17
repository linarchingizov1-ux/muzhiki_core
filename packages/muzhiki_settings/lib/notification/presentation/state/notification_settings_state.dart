import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_parameter_option.dart';

class NotificationSettingsState {
  final List<NotificationSubscriptionModel>? subscriptions;
  final Map<String, List<NotificationParameterOption>> externalOptionsByType;
  final Set<String> savingNotificationKeys;
  final String? selectedNotificationKey;
  final bool isLoading;
  final Map<String, String> externalOptionsErrorsByType;
  final Set<String> loadingExternalOptionsTypes;
  final String? error;
  final String? lastSavingError;

  const NotificationSettingsState({
    this.subscriptions,
    this.externalOptionsByType = const {},
    this.savingNotificationKeys = const {},
    this.selectedNotificationKey,
    this.externalOptionsErrorsByType = const {},
    this.loadingExternalOptionsTypes = const {},
    this.isLoading = true,
    this.error,
    this.lastSavingError,
  });

  NotificationSubscriptionModel? get selectedSubscription => subscriptions
      ?.where((item) => item.notificationKey == selectedNotificationKey)
      .firstOrNull;

  bool isNotificationSaving(String notificationKey) =>
      savingNotificationKeys.contains(notificationKey);

  NotificationSettingsState copyWith({
    List<NotificationSubscriptionModel>? subscriptions,
    Map<String, List<NotificationParameterOption>>? externalOptionsByType,
    String? selectedNotificationKey,
    Set<String>? savingNotificationKeys,
    bool? isLoading,
    Set<String>? loadingExternalOptionsTypes,
    Map<String, String>? externalOptionsErrorsByType,
    String? error,
    String? lastSavingError,
    bool clearError = false,
    bool clearLastSavingError = false,
  }) {
    return NotificationSettingsState(
      subscriptions: subscriptions ?? this.subscriptions,
      externalOptionsByType:
          externalOptionsByType ?? this.externalOptionsByType,
      selectedNotificationKey:
          selectedNotificationKey ?? this.selectedNotificationKey,
      savingNotificationKeys:
          savingNotificationKeys ?? this.savingNotificationKeys,
      isLoading: isLoading ?? this.isLoading,
      loadingExternalOptionsTypes:
          loadingExternalOptionsTypes ?? this.loadingExternalOptionsTypes,
      externalOptionsErrorsByType:
          externalOptionsErrorsByType ?? this.externalOptionsErrorsByType,
      error: clearError ? null : error ?? this.error,
      lastSavingError: clearLastSavingError
          ? null
          : lastSavingError ?? this.lastSavingError,
    );
  }
}
