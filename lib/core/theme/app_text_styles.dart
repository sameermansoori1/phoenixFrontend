import 'package:flutter/material.dart';
import '../constants/font_constants.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.background,
        fontFamily: FontConstants.montserrat,
      ),
    );
  }
}
