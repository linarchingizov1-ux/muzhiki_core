import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';

class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

class SecureTokenStorage implements TokenStorage<AuthTokens> {
  SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const accessKey = 'access_token';
  static const refreshKey = 'refresh_token';

  @override
  Future<AuthTokens?> read() async {
    final access = await _storage.read(key: accessKey);
    final refresh = await _storage.read(key: refreshKey);

    if (access == null || refresh == null) {
      return null;
    }

    return AuthTokens(accessToken: access, refreshToken: refresh);
  }

  @override
  Future<void> write(AuthTokens token) async {
    await _storage.write(key: accessKey, value: token.accessToken);

    await _storage.write(key: refreshKey, value: token.refreshToken);
  }

  @override
  Future<void> delete() async {
    await _storage.delete(key: accessKey);
    await _storage.delete(key: refreshKey);
  }
}
