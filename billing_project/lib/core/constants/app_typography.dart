import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const kFontSans = 'Inter';
  static const kFontSerif = 'PlayfairDisplay';
  static const kFontMono = 'DMMono';

  static const displaySerif = TextStyle(
    fontFamily: kFontSerif,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static const h1Serif = TextStyle(
    fontFamily: kFontSerif,
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  static const h2 = TextStyle(
    fontFamily: kFontSans,
    fontSize: 18, // Reduced from 20
    fontWeight: FontWeight.w700,
    color: AppColors.kDark,
  );

  static const h3 = TextStyle(
    fontFamily: kFontSans,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.kDark,
  );

  static const bodyLarge = TextStyle(
    fontFamily: kFontSans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.kSecondary,
  );

  static const body = TextStyle(
    fontFamily: kFontSans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.kSecondary,
  );

  static const bodySmall = TextStyle(
    fontFamily: kFontSans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.kSecondary,
  );

  static const labelSmall = TextStyle(
    fontFamily: kFontSans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    color: AppColors.kMuted,
  );

  static const caption = TextStyle(
    fontFamily: kFontSans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.kMuted,
  );

  static const priceLarge = TextStyle(
    fontFamily: kFontSans,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.kDark,
  );

  static const price = TextStyle(
    fontFamily: kFontSans,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.kDark,
  );

  static const timeDisplay = TextStyle(
    fontFamily: kFontSans,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.kDark,
  );

  static const buttonLabel = TextStyle(
    fontFamily: kFontSans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const buttonSubLabel = TextStyle(
    fontFamily: kFontSans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: Color(0xCCFFFFFF), // white 80%
  );

  static const monoAmount = TextStyle(
    fontFamily: kFontMono,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.kDark,
  );

  static const navLabel = TextStyle(
    fontFamily: kFontSans,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.kMuted,
  ); // inactive tab
}
