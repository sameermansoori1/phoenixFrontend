import 'package:flutter/material.dart';
import 'package:phoenix_app/core/theme/app_theme.dart';

class DashScreen extends StatelessWidget {
  const DashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Dashboard!',
          style: AppTheme.lightTheme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
