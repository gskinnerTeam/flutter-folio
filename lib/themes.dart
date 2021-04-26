import 'package:flutter/material.dart';

enum ThemeType {
  Orange_Light,
}

/// AppTheme is the primary means of styling colors in your application.
/// Use provider to lookup and bind to the current theme:
//      AppTheme theme = context.watch();
//      return Container(color: theme.accentColor);
class AppTheme {
  static ThemeType defaultTheme = ThemeType.Orange_Light;

  final ThemeType type;
  final bool isDark;
  final Color bg1;
  final Color surface1;
  final Color surface2;
  final Color accent1;
  final Color greyWeak;
  final Color grey;
  final Color greyMedium;
  final Color greyStrong;
  final Color focus;

  /// Darkness adjusted text color. Will be Black in light mode, and White in dark
  late Color mainTextColor;
  late Color inverseTextColor;

  /// Default constructor
  AppTheme(
      {required this.type,
      required this.bg1,
      required this.surface1,
      required this.surface2,
      required this.accent1,
      required this.greyWeak,
      required this.grey,
      required this.greyMedium,
      required this.greyStrong,
      required this.focus,
      required this.isDark}) {
    mainTextColor = isDark ? Colors.white : Colors.black;
    inverseTextColor = isDark ? Colors.black : Colors.white;
  }

  /// Creates an AppTheme from a provided Type.
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.Orange_Light:
        return AppTheme(
          isDark: false,
          type: t,
          bg1: const Color(0xfff3f3f3),
          surface1: Colors.white,
          surface2: const Color(0xffebf0f3),
          accent1: const Color(0xffff392b),
          greyWeak: const Color(0xffcccccc),
          grey: const Color(0xff999999),
          greyMedium: const Color(0xff747474),
          greyStrong: const Color(0xff333333),
          focus: const Color(0xffd81e1e),
        );
      default:
        return AppTheme.fromType(defaultTheme);
    }
  }

  // Converts AppTheme into a Material Theme Data, using whatever mappings we like
  ThemeData toThemeData() {
    var t = ThemeData.from(
      // Use the .dark() and .light() constructors to handle the text themes
      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,
      // Use ColorScheme to generate the bulk of the color theme
      colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: accent1,
          primaryVariant: shift(accent1, .1),
          secondary: accent1,
          secondaryVariant: shift(accent1, .1),
          background: bg1,
          surface: surface1,
          onBackground: mainTextColor,
          onSurface: mainTextColor,
          onError: mainTextColor,
          onPrimary: inverseTextColor,
          onSecondary: inverseTextColor,
          error: focus),
    );
    // Apply additional styling that is missed by ColorScheme
    t.copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: surface1,
          selectionHandleColor: Colors.transparent,
          selectionColor: surface1,
        ),
        buttonColor: accent1,
        highlightColor: shift(accent1, .1),
        toggleableActiveColor: accent1);
    // All done, return the ThemeData
    return t;
  }

  /// This will add luminance in dark mode, and remove it in light.
  // Allows the view to just make something "stronger" or "weaker" without worrying what the current theme brightness is
  //      color = theme.shift(someColor, .1); //-10% lum in dark mode, +10% in light mode
  Color shift(Color c, double amt) {
    amt *= (isDark ? -1 : 1);
    var hslc = HSLColor.fromColor(c); // Convert to HSL
    double lightness = (hslc.lightness + amt).clamp(0, 1.0) as double; // Add/Remove lightness
    return hslc.withLightness(lightness).toColor(); // Convert back to Color
  }
}
