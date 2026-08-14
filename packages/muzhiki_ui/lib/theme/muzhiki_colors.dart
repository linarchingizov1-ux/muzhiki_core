import 'package:flutter/material.dart';

/// Muzhiki palette. Use getters in `build` so dark/light switch applies on rebuild.
///
/// Call [depend] at the start of `build` in long-lived screens/shells so they
/// rebuild when the theme changes (do not remount [GoRouter]).
///
/// `*Light` / `*Dark` consts are for default constructor params and ThemeData.
/// Brand tokens (`white`, `blood*`, accents) stay fixed.
class MuzhikiColors {
  MuzhikiColors._();

  static Brightness brightness = Brightness.light;

  /// Notifies [depend] subscribers when [applyBrightness] changes the palette.
  static final ValueNotifier<Brightness> listenable =
      ValueNotifier(Brightness.light);

  static bool get isDark => brightness == Brightness.dark;

  static void applyBrightness(Brightness value) {
    if (brightness == value) return;
    brightness = value;
    listenable.value = value;
  }

  /// Registers [context] to rebuild when the palette brightness changes.
  static void depend(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<MuzhikiColorsScope>();
  }

  // --- Fixed / brand ---
  /// Always pure white — text/icons on photos, blood buttons, dark overlays.
  static const Color white = Colors.white;
  static const Color blood = Color.fromARGB(255, 227, 0, 22);
  static const Color backgroundBlood = Color.fromARGB(255, 242, 219, 221);
  static const Color darkBlood = Color.fromARGB(255, 112, 7, 0);
  static const Color bloodLight = Color.fromARGB(20, 227, 0, 23);
  static const Color orange = Color.fromARGB(255, 239, 171, 45);
  static const Color green = Color.fromARGB(255, 68, 206, 93);
  static const Color marsalaDark = Color(0xFF4A3534);
  static const Color marsala = Color(0xFF6B4B48);
  static const Color grey = Color.fromARGB(255, 123, 123, 123);
  static const Color greyText = Color.fromARGB(255, 161, 161, 161);

  // --- Light tokens (also used as const defaults) ---
  static const Color appBackgroudLight = Color.fromARGB(255, 243, 243, 243);
  static const Color black17Light = Color.fromARGB(255, 17, 17, 17);
  static const Color black1Light = Color.fromARGB(255, 1, 1, 1);
  static const Color black23Light = Color.fromARGB(255, 23, 23, 23);

  /// Always near-black chrome (headers / accent cards) — does not invert in dark mode.
  static const Color ink = black23Light;
  static const Color lightLight = Color.fromARGB(255, 231, 231, 231);
  static const Color alertTextGreyLight = Color.fromARGB(255, 74, 74, 74);
  static const Color darkGreyLight = Color.fromARGB(255, 61, 61, 61);
  static const Color greyLightLight = Color.fromARGB(255, 219, 219, 219);
  static const Color blackOpticalZeroLight = Color.fromARGB(181, 42, 38, 38);

  // --- Dark tokens ---
  static const Color appBackgroudDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color lightDark = Color(0xFF2C2C2C);
  static const Color greyLightDark = Color(0xFF3A3A3A);

  // --- Theme-aware getters (preferred in widgets) ---
  static Color get appBackgroud =>
      isDark ? appBackgroudDark : appBackgroudLight;

  /// Cards, sheets, bottom bars — was hard-coded white.
  static Color get surface => isDark ? surfaceDark : white;

  static Color get black17 => isDark ? white : black17Light;

  static Color get black1 => isDark ? white : black1Light;

  static Color get black23 => isDark ? const Color(0xFFF2F2F2) : black23Light;

  static Color get light => isDark ? lightDark : lightLight;

  static Color get alertTextGrey => isDark ? greyText : alertTextGreyLight;

  static Color get darkGrey => isDark ? greyLightDark : darkGreyLight;

  static Color get greyLight => isDark ? greyLightDark : greyLightLight;

  static Color get blackOpticalZero => isDark
      ? const Color.fromARGB(180, 0, 0, 0)
      : blackOpticalZeroLight;
}

/// Provides [MuzhikiColors.listenable] so [MuzhikiColors.depend] can rebuild screens.
class MuzhikiColorsScope extends InheritedNotifier<ValueNotifier<Brightness>> {
  const MuzhikiColorsScope({
    required ValueNotifier<Brightness> notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);
}
