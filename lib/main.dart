import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix_app/core/theme/app_theme.dart';
import 'package:phoenix_app/features/home/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:phoenix_app/features/home/dashboard/domain/usecases/get_dashboard_info_usecase.dart';
import 'package:phoenix_app/features/home/dashboard/presentation/bloc/dashboardBloc/dashboard_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => DashboardBloc(
                getDashboardInfoUseCase: GetDashboardInfoUseCase(
                    context.read<DashboardRepositoryImpl>()))),
      ],
      child: MaterialApp.router(
        title: 'Phoenix App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
