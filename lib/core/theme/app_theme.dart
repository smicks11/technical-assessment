import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const double _radius = 12;

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.onError,
          outline: AppColors.outline,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.buttonDisabled,
            disabledForegroundColor: AppColors.buttonDisabledText,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: AppColors.outline, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          TextTheme(
            headlineLarge: AppTextStyles.headlineLarge,
            headlineMedium: AppTextStyles.headlineMedium,
            headlineSmall: AppTextStyles.headlineSmall,
            titleLarge: AppTextStyles.titleLarge,
            titleMedium: AppTextStyles.titleMedium,
            titleSmall: AppTextStyles.titleSmall,
            bodyLarge: AppTextStyles.bodyLarge,
            bodyMedium: AppTextStyles.bodyMedium,
            bodySmall: AppTextStyles.bodySmall,
            labelLarge: AppTextStyles.labelLarge,
            labelMedium: AppTextStyles.labelMedium,
            labelSmall: AppTextStyles.labelSmall,
          ),
        ),
      );
}
