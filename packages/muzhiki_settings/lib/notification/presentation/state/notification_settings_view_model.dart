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
  final Map<String, int> _updateRequestIds = {};

  Future<void> init({bool isRefresh = false}) async {
    if (_state.subscriptions != null && !isRefresh) return;
    await getSubscriptions(isRefresh: isRefresh);
  }

  Future<void> getSubscriptions({bool isRefresh = false}) async {
    final requestId = ++_subscriptionsRequestId;

    _state = _state.copyWith(
      isSubscriptionsLoading: !isRefresh,
      clearSubscriptionsError: true,
    );
    notifyListeners();

    try {
      final subscriptions = await repository.getSubscriptions();

      if (requestId != _subscriptionsRequestId) return;

      _state = _state.copyWith(
        isSubscriptionsLoading: false,
        subscriptions: subscriptions,
      );
    } on AppException catch (e) {
      if (requestId != _subscriptionsRequestId) return;
      _state = _state.copyWith(
        isSubscriptionsLoading: false,
        subscriptionsError: e.message,
      );
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

    final notificationKey = subscription.notificationKey;
    final currentSubscription = _state.subscriptions
        ?.where((item) => item.notificationKey == notificationKey)
        .firstOrNull;
    if (currentSubscription == null) return false;

    final previousEnabled = currentSubscription.isEnabled;
    final isEnabled = !previousEnabled;

    _state = _state.copyWith(
      subscriptions: _replaceSubscription(
        updatedSubscription: currentSubscription.copyWith(isEnabled: isEnabled),
      ),
    );
    notifyListeners();

    try {
      return await _sendUpdate(
        notificationKey: notificationKey,
        isEnabled: isEnabled,
      );
    } on AppException catch (e) {
      final latestSubscription = _state.subscriptions
          ?.where((item) => item.notificationKey == notificationKey)
          .firstOrNull;
      if (latestSubscription != null) {
        _state = _state.copyWith(
          subscriptions: _replaceSubscription(
            updatedSubscription: latestSubscription.copyWith(
              isEnabled: previousEnabled,
            ),
          ),
        );
      }
      BannerController.I.showError(error: e, message: e.message);
      notifyListeners();

      return false;
    }
  }

  Future<bool> setChannels({
    required NotificationSubscriptionModel subscription,
    required List<String> channels,
  }) async {
    return await _updateDetail(
      notificationKey: subscription.notificationKey,
      channels: channels,
    );
  }

  Future<bool> setFilters({
    required NotificationSubscriptionModel subscription,
    required Map<String, dynamic> filters,
  }) async {
    return await _updateDetail(
      notificationKey: subscription.notificationKey,
      filters: filters,
    );
  }

  Future<bool> _updateDetail({
    required String notificationKey,
    List<String>? channels,
    Map<String, dynamic>? filters,
  }) async {
    _state = _state.copyWith(clearLastDetailSavingError: true);
    notifyListeners();

    try {
      return await _sendUpdate(
        notificationKey: notificationKey,
        channels: channels,
        filters: filters,
      );
    } on AppException catch (e) {
      _state = _state.copyWith(lastDetailSavingError: e.message);
      notifyListeners();

      return false;
    }
  }

  Future<bool> _sendUpdate({
    required String notificationKey,
    bool? isEnabled,
    List<String>? channels,
    Map<String, dynamic>? filters,
  }) async {
    final requestId = (_updateRequestIds[notificationKey] ?? 0) + 1;
    _updateRequestIds[notificationKey] = requestId;

    try {
      final updatedSubscription = await repository.updateSubscription(
        notificationKey: notificationKey,
        isEnabled: isEnabled,
        channels: channels,
        filters: filters,
      );

      if (requestId != _updateRequestIds[notificationKey]) return false;

      _state = _state.copyWith(
        subscriptions: _replaceSubscription(
          updatedSubscription: updatedSubscription,
        ),
      );
      notifyListeners();

      return true;
    } on AppException {
      if (requestId != _updateRequestIds[notificationKey]) return false;
      rethrow;
    }
  }

  List<NotificationSubscriptionModel>? _replaceSubscription({
    required NotificationSubscriptionModel updatedSubscription,
  }) {
    final subscriptions = _state.subscriptions;
    if (subscriptions == null) return null;

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
