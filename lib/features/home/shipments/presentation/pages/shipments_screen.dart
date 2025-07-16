import 'package:flutter/material.dart';
import 'package:phoenix_app/core/theme/app_theme.dart';

class ShipmentsScreen extends StatelessWidget {
  const ShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipments'),
      ),
      body: Center(
        child: Text(
          'Welcome to shipments!',
          style: AppTheme.lightTheme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
