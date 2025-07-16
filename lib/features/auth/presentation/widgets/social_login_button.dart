import 'package:flutter/material.dart';
import 'package:phoenix_app/core/theme/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.white,
    this.textColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: const CircleBorder(),
          elevation: 2,
          padding: EdgeInsets.zero,
        ),
        child: Icon(
          _getIconData(iconPath),
          size: 24,
          color: _getIconColor(iconPath),
        ),
      ),
    );
  }

  IconData _getIconData(String iconPath) {
    switch (iconPath) {
      case 'google':
        return Icons.g_mobiledata;
      case 'apple':
        return Icons.apple;
      case 'facebook':
        return Icons.facebook;
      default:
        return Icons.account_circle;
    }
  }

  Color _getIconColor(String iconPath) {
    switch (iconPath) {
      case 'google':
        return AppColors.error;
      case 'apple':
        return AppColors.textPrimary;
      case 'facebook':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
