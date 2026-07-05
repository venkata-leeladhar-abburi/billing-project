import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: AppTypography.kFontSans,
      primaryColor: AppColors.kOrange,
      scaffoldBackgroundColor: AppColors.kBgPage,
      colorScheme: ColorScheme.light(
        primary: AppColors.kOrange,
        secondary: AppColors.kPurple,
        error: AppColors.kError,
        surface: AppColors.kBgCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.kDark),
        titleTextStyle: AppTypography.h3,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kOrange,
          foregroundColor: Colors.white,
          textStyle: AppTypography.buttonLabel,
          shape: const StadiumBorder(),
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kBgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelStyle: AppTypography.labelSmall,
        hintStyle: AppTypography.body.copyWith(color: AppColors.kMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.kBorderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.kBorderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.kOrange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.kError, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.kBgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: AppColors.kShadowCard.color,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displaySerif,
        headlineLarge: AppTypography.h1Serif,
        headlineMedium: AppTypography.h2,
        headlineSmall: AppTypography.h3,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.bodySmall,
        labelSmall: AppTypography.labelSmall,
        labelMedium: AppTypography.caption,
      ),
    );
  }
}
