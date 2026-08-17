import 'package:flutter/foundation.dart';
import 'package:muzhiki_dependencies/muzhiki_dependencies.dart';
import 'package:muzhiki_settings/notification/data/model/notification_subscription_model.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_external_option_source.dart';
import 'package:muzhiki_settings/notification/domain/model/notification_parameter_option.dart';
import 'package:muzhiki_settings/notification/domain/repository/notification_repository.dart';
import 'package:muzhiki_settings/notification/presentation/state/notification_settings_state.dart';

class NotificationSettingsViewModel extends ChangeNotifier {
  final NotificationRepository repository;
  final Map<String, NotificationExternalOptionSource> externalOptionSources;

  NotificationSettingsViewModel({
    required this.repository,
    this.externalOptionSources = const {},
  });

  NotificationSettingsState _state = const NotificationSettingsState();
  NotificationSettingsState get state => _state;

  int _subscriptionsRequestId = 0;

  Future<void> init({bool isRefresh = false}) async {
    if (_state.subscriptions != null && !isRefresh) return;
    await getSubscriptions(isRefresh: isRefresh);
  }

  Future<void> getSubscriptions({bool isRefresh = false}) async {
    final requestId = ++_subscriptionsRequestId;

    _state = _state.copyWith(isLoading: !isRefresh, clearError: true);
    notifyListeners();

    try {
      final subscriptions = await repository.getSubscriptions();

      if (requestId != _subscriptionsRequestId) return;

      _state = _state.copyWith(isLoading: false, subscriptions: subscriptions);
    } on AppException catch (e) {
      if (requestId != _subscriptionsRequestId) return;
      _state = _state.copyWith(isLoading: false, error: e.message);
    } finally {
      if (requestId == _subscriptionsRequestId) notifyListeners();
    }
  }

  Future<void> preloadExternalOptions({
    required NotificationSubscriptionModel subscription,
    bool isRefresh = false,
  }) async {
    for (final parameter in subscription.parameters.values) {
      final source = externalOptionSources[parameter.type];
      if (source == null) continue;
      if (!isRefresh &&
          _state.externalOptionsByType.containsKey(parameter.type)) {
        continue;
      }

      await getExternalOptions(type: parameter.type, source: source);
    }
  }

  Future<List<NotificationParameterOption>?> getExternalOptions({
    required String type,
    required NotificationExternalOptionSource source,
  }) async {
    _state = _state.copyWith(
      loadingExternalOptionsTypes: {
        ..._state.loadingExternalOptionsTypes,
        type,
      },
      externalOptionsErrorsByType: {..._state.externalOptionsErrorsByType}
        ..remove(type),
    );
    notifyListeners();

    try {
      final externalOptions = await source.getParameterOptions();
      _state = _state.copyWith(
        externalOptionsByType: {
          ..._state.externalOptionsByType,
          type: externalOptions,
        },
      );

      return externalOptions;
    } on AppException catch (e) {
      _state = _state.copyWith(
        externalOptionsErrorsByType: {
          ..._state.externalOptionsErrorsByType,
          type: e.message,
        },
      );

      return null;
    } finally {
      _state = _state.copyWith(
        loadingExternalOptionsTypes: {..._state.loadingExternalOptionsTypes}
          ..remove(type),
      );
      notifyListeners();
    }
  }

  Future<bool> toggleEnabled({
    required NotificationSubscriptionModel subscription,
  }) async {
    if (!subscription.isEditable) return false;

    final isEnabled = !subscription.isEnabled;

    return await _update(
      subscription: subscription,
      isEnabled: isEnabled,
      optimisticSubscription: subscription.copyWith(isEnabled: isEnabled),
      showErrorBanner: true,
    );
  }

  Future<bool> setChannels({
    required NotificationSubscriptionModel subscription,
    required List<String> channels,
  }) async {
    return await _update(subscription: subscription, channels: channels);
  }

  Future<bool> setFilters({
    required NotificationSubscriptionModel subscription,
    required Map<String, dynamic> filters,
  }) async {
    return await _update(subscription: subscription, filters: filters);
  }

  Future<bool> _update({
    required NotificationSubscriptionModel subscription,
    bool? isEnabled,
    List<String>? channels,
    Map<String, dynamic>? filters,
    NotificationSubscriptionModel? optimisticSubscription,
    bool showErrorBanner = false,
  }) async {
    final notificationKey = subscription.notificationKey;
    if (_state.isNotificationSaving(notificationKey)) return false;

    _state = _state.copyWith(
      savingNotificationKeys: {
        ..._state.savingNotificationKeys,
        notificationKey,
      },
      clearLastSavingError: true,
      subscriptions: optimisticSubscription == null
          ? _state.subscriptions
          : _replaceSubscription(updatedSubscription: optimisticSubscription),
    );
    notifyListeners();

    try {
      final updatedSubscription = await repository.updateSubscription(
        notificationKey: notificationKey,
        isEnabled: isEnabled,
        channels: channels,
        filters: filters,
      );

      _state = _state.copyWith(
        subscriptions: _replaceSubscription(
          updatedSubscription: updatedSubscription,
        ),
      );

      return true;
    } on AppException catch (e) {
      _state = _state.copyWith(
        subscriptions: _replaceSubscription(updatedSubscription: subscription),
        lastSavingError: showErrorBanner ? null : e.message,
        clearLastSavingError: showErrorBanner,
      );

      if (showErrorBanner) {
        BannerController.I.showError(error: e, message: e.message);
      }

      return false;
    } finally {
      _state = _state.copyWith(
        savingNotificationKeys: {..._state.savingNotificationKeys}
          ..remove(notificationKey),
      );
      notifyListeners();
    }
  }

  List<NotificationSubscriptionModel> _replaceSubscription({
    required NotificationSubscriptionModel updatedSubscription,
  }) {
    final subscriptions = _state.subscriptions;
    if (subscriptions == null) return [updatedSubscription];

    return [
      for (final item in subscriptions)
        item.notificationKey == updatedSubscription.notificationKey
            ? updatedSubscription
            : item,
    ];
  }

  void setSelectedKey(String notificationKey) {
    _state = _state.copyWith(selectedNotificationKey: notificationKey);
    notifyListeners();
  }

  void clearExternalOptions() {
    _state = _state.copyWith(
      externalOptionsByType: const {},
      externalOptionsErrorsByType: const {},
    );
  }
}
