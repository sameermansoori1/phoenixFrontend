import 'package:flutter/material.dart';
import '../constants/font_constants.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: FontConstants.montserrat,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgContainer,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: AppColors.surface,
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.montserrat,
        ),
      ),
      textTheme: AppTextStyles.textTheme,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
    );
  }
}
