import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/animation_demo_screen.dart';
import 'providers/app_state_provider.dart';

/// The main Learning App widget.
class LearningApp extends ConsumerWidget {
  const LearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboardingAsync = ref.watch(hasCompletedOnboardingProvider);

    return hasCompletedOnboardingAsync.when(
      data: (hasCompletedOnboarding) => MaterialApp.router(
        title: 'まなびアプリ',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.learning(),
        routerConfig: _createRouter(hasCompletedOnboarding),
      ),
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.learning(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stack) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.learning(),
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
          pageBuilder: (context, state) => CloudTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/animation-demo',
          pageBuilder: (context, state) => StarBurstTransitionPage(
            key: state.pageKey,
            child: const AnimationDemoScreen(),
          ),
          routes: [
            GoRoute(
              path: 'rainbow-demo',
              pageBuilder: (context, state) => RainbowWipeTransitionPage(
                key: state.pageKey,
                direction: RainbowDirection.leftToRight,
                child: const RainbowDemoScreen(),
              ),
            ),
          ],
        ),
        // Add more routes as needed
      ],
    );
  }
}
