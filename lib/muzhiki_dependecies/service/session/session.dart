import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:muzhiki_core/muzhiki_core.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/exception/network_map_error.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/token_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/network/url_launch/url_launch.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/extension/roles_company.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/model/session_roles.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/model/user.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

enum AuthState { init, load, inBrows, success, error }

enum TypeApp {
  master("mp_master_app", "app.mpmaster.com"),
  bussines("mp_business_mobile_app", "app.mpbussines.com"),
  support("mp_support_app", "app.mpsupport.com"),
  client("mp_client_app", "app.mpclient.com");

  final String nameApp;
  final String scheme;
  const TypeApp(this.nameApp, this.scheme);
}

class SessionApp extends ChangeNotifier {
  final TypeApp typeApp;
  final PersistCookieJar cookieJar;
  final HiveCacheStore hiveStore;
  final SharedPreferences sharedPreferences;
  final Fresh<AuthTokens> fresh;
  final SecureTokenStorage tokenStorage;
  final Dio dioRefresh;
  final Dio dio;
  final bool getRoles;
  final UserSession userSession;

  StreamSubscription<AuthenticationStatus>? _authSub;

  AuthenticationStatus _status = AuthenticationStatus.initial;
  AuthenticationStatus get status => _status;

  bool get isAuth => _status == AuthenticationStatus.authenticated;
  bool get isUnauth => _status == AuthenticationStatus.unauthenticated;
  bool get isInitial => _status == AuthenticationStatus.initial;
  Future<String?> get accessToken async {
    final storage = await tokenStorage.read();
    return storage?.accessToken;
  }

  final Completer<void> _ready = Completer<void>();
  Future<void> get ready => _ready.future;
  UserModel? _user;
  UserModel? get user => _user;
  SessionApp({
    required this.tokenStorage,
    required this.typeApp,
    required this.dio,
    this.getRoles = false,
    required this.userSession,
    required this.dioRefresh,
    required this.sharedPreferences,
    required this.fresh,
    required this.cookieJar,
    required this.hiveStore,
  });

  Future<UserModel?> getRolesBased({
    required UserModel? currUser,
    required String token,
  }) async {
    if (currUser == null) return null;

    final saveDateTime = currUser.createdAt;

    if (saveDateTime == null ||
        DateTime.now().difference(saveDateTime).inHours >= 1) {
      try {
        final rolesData = await dioRefresh.get(
          "https://api.master.muzhiki.pro/api/v1/get-roles",
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (rolesData.data != null) {
          final newRoles = RolesModel.fromJson(rolesData.data["data"]);

          final companies = newRoles.info.getCompaniesByRole(
            currUser.roles?.currentRole,
          );

          final allowedInformator = newRoles.info.accessAllowedInformator;
          final savedCompanyId = currUser.selectedRolesCompany;
          final exists = companies.any((c) => c.id == savedCompanyId);

          final validCompanyId = exists
              ? savedCompanyId
              : (companies.isNotEmpty ? companies.first.id : "");

          currUser = currUser.copyWith(
            isAllowedAccessInformator: allowedInformator,
            roles: newRoles,
            selectedRolesCompany: validCompanyId,
            createdAt: DateTime.now(),
          );

          await userSession.saveUserSession(currUser);
        }
      } catch (_) {
        return currUser;
      }
    }

    return currUser;
  }

  Future<void> init() async {
    final storage = await tokenStorage.read();

    if (storage != null && storage.accessToken.isNotEmpty) {
      _status = AuthenticationStatus.authenticated;
      var currUser = await userSession.restoreUser();
      bool? allowedInformator;

      if (getRoles) {
        await getRolesBased(currUser: currUser, token: storage.accessToken);
      }

      allowedInformator ??= currUser?.roles?.info.accessAllowedInformator;

      _user = currUser?.copyWith(isAllowedAccessInformator: allowedInformator);
    } else {
      _status = AuthenticationStatus.unauthenticated;
      cleareSession();
    }

    _authSub = fresh.authenticationStatus.listen((status) {
      if (_status == status) return;
      _status = status;
      notifyListeners();
    });
    _ready.complete();
    notifyListeners();
  }

  Future<void> selectedCompany({required String id}) async {
    if (_user == null) return;
    _user = _user!.copyWith(selectedRolesCompany: id);
    await userSession.saveSelectedUserCompany(id: id, userId: user!.mpid);
    notifyListeners();
  }

  void refreshSession() async => await fresh.refreshToken();

  Stream<AuthState> loginSession({String path = '/'}) async* {
    final talker = Talker();
    await MuzhikiUrlLaunch.I.close();
    yield AuthState.init;
    await sharedPreferences.remove('pkce_verifier');
    try {
      yield AuthState.load;

      final redirectUri = '${typeApp.scheme}://auth/';

      final appAuth = FlutterAppAuth();
      AuthorizationResponse? authResponse;

      yield AuthState.inBrows;

      try {
        final authUrl = Uri.https('id2.muzhiki.pro', path).toString();

        authResponse = await appAuth
            .authorize(
              AuthorizationRequest(
                'dummy_client_id',
                redirectUri,
                serviceConfiguration: AuthorizationServiceConfiguration(
                  authorizationEndpoint: authUrl,
                  tokenEndpoint: '',
                ),
                additionalParameters: {
                  'redirect_url': redirectUri,
                  "app_name": typeApp.nameApp,
                },
              ),
            )
            .timeout(const Duration(minutes: 15));
      } on TimeoutException {
        await sharedPreferences.remove('pkce_verifier');
        MuzhikiDependencies.I.banner.show(message: 'Время авторизации вышло');
        yield AuthState.error;
        return;
      } catch (e, st) {
        final error = AppErrorMapper.I.map(e, st);
        talker.debug("Ошибка ${error.message}, Оригинал ${error.debugMessage}");
        if (error.message != "Авторизация отменена пользователем.") {
          MuzhikiDependencies.I.banner.show(message: error.message);
        }
        yield AuthState.error;
        return;
      }
      talker.debug("Ответ от сервера: $authResponse");
      String? extractedCode = authResponse.authorizationCode;

      if (extractedCode == null &&
          authResponse.authorizationAdditionalParameters != null) {
        extractedCode =
            authResponse.authorizationAdditionalParameters!['auth_code'];
      }

      if (extractedCode != null && extractedCode.isNotEmpty) {
        await sharedPreferences.setString(
          'pkce_verifier',
          authResponse.codeVerifier ?? '',
        );
      }

      final verifier = sharedPreferences.getString('pkce_verifier') ?? '';

      final response = await dioRefresh.post(
        'https://auth.muzhiki.pro/api/v1/auth/token',
        data: {
          'code': authResponse.authorizationAdditionalParameters!['auth_code'],
          'code_verifier': verifier,
          'mode': 'cookie',
        },
      );

      final token = response.data['data']?['access_token'] as String?;
      RolesModel? roles;
      if (getRoles == true) {
        try {
          final rolesData = await dioRefresh.get(
            'https://api.master.muzhiki.pro/api/v1/get-roles',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          roles = RolesModel.fromJson(rolesData.data["data"]);
        } catch (e) {
          MuzhikiDependencies.I.banner.show(
            message: 'Ошибка при получении роли пользователя',
          );
        }
      }

      if (token == null || token.isEmpty) {
        MuzhikiDependencies.I.banner.show(message: 'Авторизация отклонена');
        yield AuthState.error;
        return;
      }

      final userJson = response.data['data']?['user'];

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

      final savedCompanyId = sharedPreferences.getString(
        "selected_company_${userJson['id']}",
      );

      String? selectedCompany = savedCompanyId;
      bool allowedInformator = false;

      if (roles != null) {
        allowedInformator = roles.info.accessAllowedInformator;
        final companies = roles.info.getCompaniesByRole(roles.currentRole);

        final hasSavedCompany = companies.any((c) => c.id == savedCompanyId);

        if (!hasSavedCompany) {
          selectedCompany = companies.isNotEmpty ? companies.first.id : null;
        }
      }
      final isFirstAuth = sharedPreferences.getBool('first_auth');
      final user = UserModel(
        isAllowedAccessInformator: allowedInformator,
        isFirstAuth: isFirstAuth ?? true,
        selectedRolesCompany: selectedCompany ?? "",
        createdAt: DateTime.now(),
        roles: roles,
        firstName: firstName,
        lastName: lastName,
        mpid: userJson['id'].toString(),
        username: userJson['full_name'] ?? '',
        isFake: userJson['is_fake'] ?? false,
        phone: userJson['phone'] ?? '',
      );

      await userSession.saveUserSession(user);
      _user = user;
      notifyListeners();
      Future.delayed(
        const Duration(seconds: 3),
        () => fresh.setToken(AuthTokens(accessToken: token, refreshToken: "")),
      );

      yield AuthState.success;
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);
      MuzhikiDependencies.I.banner.show(message: error.message);
      yield AuthState.error;
    }
  }

  Future<void> removeAccount({required String phone}) async {
    final response = await dio.delete(
      'https://auth.muzhiki.pro/api/v1/delete-account',
      data: {"phone": phone},
    );
    await dio.post(
      'https://auth.muzhiki.pro/api/v1/logout',
      data: {"app_name": typeApp.nameApp},
      options: Options(extra: {'isRefreshRequest': false, 'showError': false}),
    );
    if (response.data['success'] == true) {
      cleareSession();
    }
  }

  Future<UserModel> editAccount({
    required Map<String, dynamic> userData,
  }) async {
    try {
      await dio.post(
        "https://auth.muzhiki.pro/api/v1/change-info",
        data: {
          "name": userData['first_name'],
          "last_name": userData['last_name'],
          "phone": _user!.phone,
        },
      );
      _user = _user!.copyWith(
        firstName: userData['first_name'],
        lastName: userData['last_name'],
      );
      await userSession.saveUserSession(_user!);
      await userSession.restoreUser();
      _user = user;
      return _user!;
    } catch (e, st) {
      throw AppErrorMapper.I.map(e, st);
    }
  }

  Future<void> logoutSession({VoidCallback? firebaseRemoveFCM}) async {
    try {
      await dio.post(
        "https://auth.muzhiki.pro/api/v1/logout",
        data: {"app_name": typeApp.nameApp},
        options: Options(
          extra: {'isRefreshRequest': false, 'showError': false},
        ),
      );
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);
      MuzhikiDependencies.I.banner.show(message: error.message);
    } finally {
      firebaseRemoveFCM?.call();
      cleareSession();
    }
  }

  void cleareSession() {
    fresh.clearToken();
    userSession.clearUserSession();
    cookieJar.deleteAll();
    try {
      hiveStore.clean();
    } catch (e, st) {
      final error = AppErrorMapper.I.map(e, st);
      MuzhikiDependencies.I.banner.show(message: error.message);
      hiveStore.delete('dio_cache');
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
