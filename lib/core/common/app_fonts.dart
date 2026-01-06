import 'package:flutter/material.dart';

class AppFonts {
  static const String cabin = 'Cabin';
  static const String amaranth = 'Amaranth';
}

extension TextStyleHelpers on TextStyle {
  TextStyle get amaranth => copyWith(fontFamily: AppFonts.amaranth);
  TextStyle get cabin => copyWith(fontFamily: AppFonts.cabin);

  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
}
