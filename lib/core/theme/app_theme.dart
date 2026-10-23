import 'package:flutter/material.dart';

/// Banková apka – plne saturovaná žltá #FFD500 + dark mode podľa prototypu.
class AppColors {
  // Brand
  static const brand = Color(0xFFFFD500);
  static const brandDeep = Color(0xFFF5C400);

  // Light
  static const ink = Color(0xFF1F2937);
  static const cream = Color(0xFFF7F8FA);
  static const card = Colors.white;
  static const muted = Color(0xFF6B7280);
  static const line = Color(0xFFEEF1F5);

  // Dark
  static const darkBg = Color(0xFF14181D);
  static const darkCard = Color(0xFF1D2229);
  static const darkText = Color(0xFFF3F5F7);
  static const darkMuted = Color(0xFF9AA3AF);
  static const darkLine = Color(0xFF2C333D);
}

class AppTheme {
  static const fontFamily = 'PlusJakartaSans';

  static TextTheme _textTheme(Brightness brightness) {
    final onBg = brightness == Brightness.light ? AppColors.ink : AppColors.darkText;
    final muted = brightness == Brightness.light ? AppColors.muted : AppColors.darkMuted;
    final base = Typography.material2021().black.apply(
      fontFamily: fontFamily,
      bodyColor: onBg,
      displayColor: onBg,
    );
    return base.copyWith(
      bodyLarge: base.bodyLarge?.copyWith(color: onBg),
      bodyMedium: base.bodyMedium?.copyWith(color: muted),
      bodySmall: base.bodySmall?.copyWith(color: muted),
      titleLarge: base.titleLarge?.copyWith(color: onBg, fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(color: onBg, fontWeight: FontWeight.w600),
      headlineMedium: base.headlineMedium?.copyWith(color: onBg, fontWeight: FontWeight.w700),
      headlineSmall: base.headlineSmall?.copyWith(color: onBg, fontWeight: FontWeight.w600),
      labelLarge: base.labelLarge?.copyWith(color: onBg),
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: fontFamily,
    textTheme: _textTheme(Brightness.light),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      onPrimary: AppColors.ink,
      secondary: AppColors.brandDeep,
      surface: AppColors.card,
      onSurface: AppColors.ink,
      error: const Color(0xFFD93025),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.cream,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardTheme(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.card,
      indicatorColor: AppColors.brand.withOpacity(0.25),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    textTheme: _textTheme(Brightness.dark),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      onPrimary: AppColors.ink,
      secondary: AppColors.brandDeep,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkText,
      error: const Color(0xFFE5574A),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.darkBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBg,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardTheme(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      indicatorColor: AppColors.brand.withOpacity(0.25),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkText),
      ),
    ),
  );
}
