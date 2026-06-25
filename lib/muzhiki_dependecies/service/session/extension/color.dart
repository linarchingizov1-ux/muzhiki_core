import 'dart:ui';

import 'package:muzhiki_core/muzhiki_support/app/config/app_colors.dart';

extension ColorExtension on String {
  Color get toColor {
    try {
      final hex = trim().replaceAll('#', '');

      if (hex.isEmpty) {
        return AppColors.light;
      }

      String normalized;

      switch (hex.length) {
        case 3:
          normalized = hex.split('').map((e) => '$e$e').join();
          normalized = 'FF$normalized';
          break;

        case 6:
          normalized = 'FF$hex';
          break;

        case 8:
          normalized = hex;
          break;

        default:
          return AppColors.light;
      }

      final value = int.tryParse(normalized, radix: 16);

      if (value == null) {
        return AppColors.light;
      }

      return Color(value);
    } catch (_) {
      return AppColors.light;
    }
  }
}
