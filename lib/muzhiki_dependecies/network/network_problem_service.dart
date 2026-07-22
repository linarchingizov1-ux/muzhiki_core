import 'package:dio/dio.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/extension/dio_error_extension.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/ui/dialog/network_problem_dialog.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_controller.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/app_banner/app_banner_widget.dart';
import 'package:muzhiki_core/muzhiki_support/app/feature/widgets/app_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkProblemService {
  NetworkProblemService({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const _errorMaxCount = 4;
  static const _errorInterval = Duration(minutes: 2);
  static const _sheetInterval = Duration(hours: 24);
  static const _sheetShownAtKey = 'network_problem_sheet_shown_at';

  final List<DateTime> _errorTimes = [];
  bool _isSheetShowing = false;

  void onRequestError(DioException err) {
    if (!err.isConnectionProblem) return;
    if (_isSheetShowing) return;

    final now = DateTime.now();
    _errorTimes.add(now);
    _errorTimes.removeWhere((time) => now.difference(time) > _errorInterval);
    if (_errorTimes.length < _errorMaxCount) return;
    _errorTimes.clear();

    if (_canShowSheet()) {
      _showSheet();
    } else {
      BannerController.I.show(
        type: BannerType.glasses,
        title: 'И снова проблемы с сетью 😢',
        message:
            'Это не баг, запрос оборвался из-за нестабильной сети. '
            'Рекомендуем переподключиться и попробовать ещё раз',
      );
    }
  }

  bool _canShowSheet() {
    final milliseconds = sharedPreferences.getInt(_sheetShownAtKey);
    if (milliseconds == null) return true;
    final shownAt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateTime.now().difference(shownAt) >= _sheetInterval;
  }

  Future<void> _showSheet() async {
    if (_isSheetShowing) return;
    _isSheetShowing = true;
    await sharedPreferences.setInt(
      _sheetShownAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    try {
      await AppDialog.standart(child: const NetworkIssueDialog());
    } finally {
      _isSheetShowing = false;
      _errorTimes.clear();
    }
  }
}
