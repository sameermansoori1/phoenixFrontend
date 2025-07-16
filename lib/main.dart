import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_app/core/theme/app_theme.dart';
import 'package:phoenix_app/routes/router.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Phoenix App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
