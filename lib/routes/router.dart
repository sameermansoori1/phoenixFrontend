import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_app/features/auth/presentation/pages/login_screen.dart';
import 'package:phoenix_app/features/home/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:phoenix_app/features/home/home_screen.dart';
import 'package:phoenix_app/features/home/shipments/presentation/pages/shipment_history_screen.dart';
import 'package:phoenix_app/features/home/aboutMe/presentation/pages/about_me_screen.dart';
import 'package:phoenix_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:phoenix_app/features/home/shipments/presentation/bloc/shipment_bloc.dart';
import 'package:phoenix_app/features/home/shipments/data/datasources/shipment_remote_data_source.dart';
import 'package:phoenix_app/features/home/shipments/data/datasources/shipment_local_data_source.dart';
import 'package:phoenix_app/features/home/shipments/data/repositories/shipment_repository_impl.dart';
import 'package:phoenix_app/features/home/shipments/domain/usecases/get_shipments_usecase.dart';
import 'package:phoenix_app/core/utils/network_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoenix_app/features/home/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:phoenix_app/features/home/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:phoenix_app/features/home/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:phoenix_app/features/home/dashboard/domain/usecases/get_dashboard_info_usecase.dart';

// Custom page builder for fade transitions
Page<T> buildFadePage<T extends Object?>({
  required Widget child,
  required GoRouterState state,
  int durationMs = 300,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration(milliseconds: durationMs),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Splash route
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => buildFadePage(
        child: const SplashScreen(),
        state: state,
        durationMs: 500,
      ),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => buildFadePage(
        child: const LoginScreen(),
        state: state,
        durationMs: 500,
      ),
    ),

    // Main app shell
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(child: child);
      },
      pageBuilder: (context, state, child) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: HomeScreen(child: child),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            final networkClient = NetworkClient();
            final remoteDataSource =
                DashboardRemoteDataSource(networkClient: networkClient);
            final localDataSource = DashboardLocalDataSource();
            final repository = DashboardRepositoryImpl(
              remoteDataSource: remoteDataSource,
              localDataSource: localDataSource,
            );
            final getDashboardInfoUseCase = GetDashboardInfoUseCase(repository);
            return buildFadePage(
              child: DashboardScreen(
                getDashboardInfoUseCase: getDashboardInfoUseCase,
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/shipments',
          pageBuilder: (context, state) {
            final networkClient = NetworkClient();
            final remoteDataSource =
                ShipmentRemoteDataSource(networkClient: networkClient);
            final localDataSource = ShipmentLocalDataSource();
            final repository = ShipmentRepositoryImpl(
              remoteDataSource: remoteDataSource,
              localDataSource: localDataSource,
            );
            final getShipmentsUseCase = GetShipmentsUseCase(repository);
            return buildFadePage(
              child: BlocProvider(
                create: (_) =>
                    ShipmentBloc(getShipmentsUseCase: getShipmentsUseCase)
                      ..add(FetchShipments()),
                child: const ShipmentHistoryScreen(),
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          path: '/aboutMe',
          pageBuilder: (context, state) => buildFadePage(
            child: const AboutMeScreen(),
            state: state,
          ),
        ),
      ],
    ),
  ],
);
