  // Core colors
  import 'package:flutter/material.dart';


  class AppColors {
  static const Color backgroundColor = Color(0xFF171717);
  static const Color  primaryColor= Color(0xFF51F191);
  static const Color  secondaryColor= Color(0xFFB3FED1);
  static const Color accentColor = Color(0xFF272627);
  static const Color dangerColor = Color(0xFFFF5252);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color subTextColor = Color(0xFFA0A0A5);
  static const Color transparentColor = Colors.transparent;
  }

  class Textfont{
  static const String fontFamily = 'Poppins';

  static const TextStyle large = TextStyle(
    fontFamily: fontFamily,
    fontSize: 35,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: AppColors.textColor,
  );
  static const TextStyle subText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.subTextColor,
  );
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );
  static const TextStyle button2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.backgroundColor,
  );
  static const TextStyle appBar = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: AppColors.textColor,
  );
  }
    