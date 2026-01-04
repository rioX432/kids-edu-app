import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'providers/app_state_provider.dart';

/// The main Picture Book App widget.
class PictureBookApp extends ConsumerWidget {
  const PictureBookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboarding = ref.watch(hasCompletedOnboardingProvider);

    return MaterialApp.router(
      title: 'えほんアプリ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.pictureBookApp, // Uses night mode theme
      routerConfig: _createRouter(hasCompletedOnboarding),
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
          builder: (context, state) => const HomeScreen(),
        ),
        // Add more routes as needed (story list, story reader, etc.)
      ],
    );
  }
}
