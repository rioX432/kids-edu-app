import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'providers/app_state_provider.dart';

/// The main Picture Book App widget.
class PictureBookApp extends ConsumerWidget {
  const PictureBookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboardingAsync = ref.watch(hasCompletedOnboardingProvider);

    return hasCompletedOnboardingAsync.when(
      data: (hasCompletedOnboarding) => MaterialApp.router(
        title: 'えほんアプリ',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.pictureBook(nightMode: true),
        routerConfig: _createRouter(hasCompletedOnboarding),
      ),
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.pictureBook(nightMode: true),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stack) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.pictureBook(nightMode: true),
        home: Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }

  GoRouter _createRouter(bool hasCompletedOnboarding) {
    return GoRouter(
      initialLocation: hasCompletedOnboarding ? '/home' : '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => BookTurnTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        // Add more routes as needed (story list, story reader, etc.)
      ],
    );
  }
}
