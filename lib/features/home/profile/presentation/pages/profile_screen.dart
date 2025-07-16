import 'package:flutter/material.dart';
import 'package:phoenix_app/core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Profile!',
          style: AppTheme.lightTheme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
