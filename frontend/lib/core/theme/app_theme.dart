import 'package:flutter/material.dart';

class AppColors {
  static const Color accentPrimary = Color(0xFF3B82F6); // blue-500
  static const Color accentSecondary = Color(0xFF60A5FA); // blue-400
  static const Color accentTertiary = Color(0xFF22C55E); // green-500

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  static const Color textPrimary = Color(0xFF111827); // gray-900
  static const Color textSecondary = Color(0xFF4B5563); // gray-600

  static const Color outline = Color(0xFFE5E7EB); // gray-200
  static const Color outlineVariant = Color(0xFFD1D5DB); // gray-300

  static const Color error = Color(0xFFDC2626); // red-600
}

class AppTheme {
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.accentPrimary,
    onPrimary: Colors.white,
    secondary: AppColors.accentSecondary,
    onSecondary: Colors.white,
    tertiary: AppColors.accentTertiary,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.background,
    onBackground: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: Colors.black12,
    scrim: Colors.black54,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.accentPrimary,
  );

  static ThemeData get light {
    final textTheme = _textTheme(_lightScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightScheme,
      scaffoldBackgroundColor: _lightScheme.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightScheme.surface,
        foregroundColor: _lightScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: _lightScheme.surface,
        elevation: 1,
        margin: const EdgeInsets.all(0),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _lightScheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: _lightScheme.outlineVariant,
        space: 1,
      ),
      iconTheme: IconThemeData(
        color: _lightScheme.onSurfaceVariant,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _lightScheme.primary,
          foregroundColor: _lightScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightScheme.primary,
          side: BorderSide(color: _lightScheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        filled: true,
        fillColor: _lightScheme.surface,
        hintStyle: TextStyle(color: _lightScheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightScheme.primary, width: 1.5),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: _lightScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return _lightScheme.primary;
          return _lightScheme.outlineVariant;
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightScheme.onSurface,
        contentTextStyle: TextStyle(color: _lightScheme.surface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    return Typography.blackMountainView.apply(
      displayColor: scheme.onBackground,
      bodyColor: scheme.onBackground,
    ).copyWith(
      headlineSmall: Typography.blackMountainView.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleLarge: Typography.blackMountainView.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelLarge: Typography.blackMountainView.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}


