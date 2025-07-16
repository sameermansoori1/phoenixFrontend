import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_app/features/auth/presentation/pages/login_screen.dart';
import 'package:phoenix_app/features/home/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:phoenix_app/features/home/home_screen.dart';
import 'package:phoenix_app/features/home/shipments/presentation/pages/shipments_screen.dart';
import 'package:phoenix_app/features/home/profile/presentation/pages/profile_screen.dart';
import 'package:phoenix_app/features/splash/presentation/pages/splash_screen.dart';

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
          pageBuilder: (context, state) => buildFadePage(
            child: const ShipmentsScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: '/dash',
          pageBuilder: (context, state) => buildFadePage(
            child: const DashScreen(),
            state: state,
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => buildFadePage(
            child: const ProfileScreen(),
            state: state,
          ),
        ),
      ],
    ),
  ],
);
