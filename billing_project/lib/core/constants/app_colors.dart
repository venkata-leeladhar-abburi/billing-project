import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const kOrange = Color(0xFFE8680A); // primary CTA
  static const kOrangeDark = Color(0xFFC8560A); // pressed state
  static const kOrangeLight = Color(0xFFFFF3E8); // orange tint bg
  static const kPurple = Color(0xFF6B4EFF); // home header gradient
  static const kPurpleLight = Color(0xFF8B6FFF); // header gradient mid
  static const kGreen = Color(0xFF16A34A); // success/sent/free
  static const kGreenLight = Color(0xFFF0FDF4); // green tint bg
  static const kBlue = Color(0xFF2563EB); // info/links/codes
  static const kBlueLight = Color(0xFFEFF6FF); // blue tint bg
  static const kDark = Color(0xFF1A1A1A); // primary text
  static const kSecondary = Color(0xFF555555); // secondary text
  static const kMuted = Color(0xFF999999); // placeholder/timestamp
  static const kBorderGray = Color(0xFFE5E5E5); // card/input borders
  static const kDivider = Color(0xFFF0F0F0); // section dividers
  static const kBgPage = Color(0xFFF5F5F5); // page background (NOT white)
  static const kBgCard = Color(0xFFFFFFFF); // card background
  static const kError = Color(0xFFDC2626); // error states only
  static const kWarning = Color(0xFFF59E0B); // credit low/warning
  static const kNavy = Color(0xFF1A1A2E); // super admin header
  static const kNavyCard = Color(0xFF242440); // navy card surface

  // Gradients
  static const kGradientPurple = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [kPurple, kPurpleLight, kBgPage],
    stops: [0.0, 0.6, 1.0],
  ); // home header

  static const kGradientOrange = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [kOrange, Color(0xFFF07820), kBgCard],
    stops: [0.0, 0.6, 1.0],
  ); // detail/flow headers

  static const kGradientSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFA8D4F5), Color(0xFFC8E8FF), kBgPage],
    stops: [0.0, 0.5, 1.0],
  ); // search/form headers

  static const kGradientNavy = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [kNavy, Color(0xFF2D2D4E), Colors.transparent],
    stops: [0.0, 0.6, 1.0],
  ); // super admin headers

  // Shadows
  static const kShadowCard = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 4,
    offset: Offset(0, 1),
  );

  static const kShadowModal = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    offset: Offset(0, -2),
  );

  static const kShadowFloat = BoxShadow(
    color: Color(0x29000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );
}
