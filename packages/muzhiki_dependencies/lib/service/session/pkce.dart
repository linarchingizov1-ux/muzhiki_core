import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PkcePair {
  final String verifier;
  final String challenge;
  
  const PkcePair({
    required this.verifier,
    required this.challenge,
  });

  static String _base64UrlNoPadding(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~';
    final rnd = Random.secure();
    return List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  static Future<PkcePair> generate() async {
    final verifier = _randomString(64);
    final digest = sha256.convert(utf8.encode(verifier)).bytes;
    final challenge = _base64UrlNoPadding(digest);
    return PkcePair(verifier: verifier, challenge: challenge);
  }
}
