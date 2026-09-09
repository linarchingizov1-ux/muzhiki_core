import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoriesConfig {
  final Dio dio;
  final int placeId;
  final String creativesUrl;
  final SharedPreferences sharedPreferences;

  const StoriesConfig({
    required this.dio,
    required this.placeId,
    required this.creativesUrl,
    required this.sharedPreferences,
  });
}
