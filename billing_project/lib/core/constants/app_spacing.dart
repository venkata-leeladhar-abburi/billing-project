import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0; // base unit
  static const double s12 = 12.0;
  static const double s16 = 16.0; // standard page horizontal padding
  static const double s20 = 20.0;
  static const double s24 = 24.0; // between sections
  static const double s32 = 32.0;
  static const double s48 = 48.0; // bottom safe area above sticky bar

  static final BorderRadius rXs = BorderRadius.circular(4);
  static final BorderRadius rSm = BorderRadius.circular(8);
  static final BorderRadius rMd = BorderRadius.circular(12);
  static final BorderRadius rLg = BorderRadius.circular(16);
  static final BorderRadius rXl = BorderRadius.circular(20);
  static final BorderRadius rPill = BorderRadius.circular(100);
  static final BorderRadius rFull = BorderRadius.circular(9999);

  static const EdgeInsets kPagePadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets kCardPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
}
