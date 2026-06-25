import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';

class SecureStringTokenStorage implements TokenStorage<String> {
  SecureStringTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _key = 'access_token';

  @override
  Future<String?> read() async {
    return _storage.read(key: _key);
  }

  @override
  Future<void> write(String token) async {
    await _storage.write(key: _key, value: token);
  }

  @override
  Future<void> delete() async {
    await _storage.delete(key: _key);
  }
}
