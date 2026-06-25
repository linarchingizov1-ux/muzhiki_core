import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:muzhiki_core/muzhiki_dependecies/service/session/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageModel {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secure;
  final SecureStringTokenStorage token;
  final Directory directory;

  const StorageModel({
    required this.sharedPreferences,
    required this.secure,
    required this.token,
    required this.directory,
  });
}
