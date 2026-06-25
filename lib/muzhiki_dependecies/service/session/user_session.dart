import 'dart:convert';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  final SharedPreferences sharedPreferences;
  UserSession(this.sharedPreferences);

  Future<void> clearRoles() async {}

  Future<void> clearUserSession() async {
    await sharedPreferences.remove('user_session');
  }

  Future<void> saveUserSession(UserModel user) async {
    final userJson = jsonEncode(user.toJson());

    await sharedPreferences.setString('user_session', userJson);
  }

  Future<UserModel?> restoreUser() async {
    final sessionData = sharedPreferences.getString('user_session');

    if (sessionData != null) {
      return _restoreFromNewSession(sessionData);
    }

    final legacyUser = _restoreLegacyUser();

    if (legacyUser != null) {
      await saveUserSession(legacyUser);

      await _clearLegacySession();

      return legacyUser;
    }

    return null;
  }

  Future<void> saveSelectedUserCompany({
    required String id,
    required String userId,
  }) async {
    await sharedPreferences.setString("selected_company_$userId", id);
  }

  Future<void> saveUserJson(Map<String, dynamic> userJson) async {
    final data = sharedPreferences.getString('user_session');
    if (data == null) return;
    UserModel user;
    user = UserModel.fromJson(jsonDecode(data));

    final fullName = (userJson['full_name'] ?? '').toString();

    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    String firstName = '';
    String lastName = '';

    if (parts.isNotEmpty) {
      firstName = parts.first;
    }

    if (parts.length > 1) {
      lastName = parts.sublist(1).join(' ');
    }

    user = user.copyWith(
      firstName: firstName,
      lastName: lastName,
      mpid: userJson['id'].toString(),
      username: fullName,
      isFake: userJson['is_fake'] ?? false,
      phone: userJson['phone'] ?? '',
    );
    saveUserSession(user);
  }

  UserModel? _restoreLegacyUser() {
    final id = sharedPreferences.getString('user_id');

    if (id == null) return null;

    return UserModel(
      firstName: sharedPreferences.getString('first_name') ?? '',
      lastName: sharedPreferences.getString('last_name') ?? '',
      mpid: id,
      username: sharedPreferences.getString('username') ?? '',
      isFake: sharedPreferences.getBool('is_fake') ?? false,
      phone: sharedPreferences.getString('phone') ?? '',
      isFirstAuth: sharedPreferences.getBool('first_auth') ?? true,
    );
  }

  Future<void> _clearLegacySession() async {
    await sharedPreferences.remove('user_id');
    await sharedPreferences.remove('username');
    await sharedPreferences.remove('is_fake');
    await sharedPreferences.remove('phone');
    await sharedPreferences.remove('first_name');
    await sharedPreferences.remove('last_name');
  }

  Future<UserModel> _restoreFromNewSession(String data) async {
    var user = UserModel.fromJson(jsonDecode(data));

    final isFirstAuth = sharedPreferences.getBool('first_auth');
    final companyId = sharedPreferences.getString(
      'selected_company_${user.mpid}',
    );

    return user.copyWith(
      isFirstAuth: isFirstAuth,
      selectedRolesCompany: companyId,
    );
  }
}
