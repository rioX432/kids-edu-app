import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for kids
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.backgroundLight,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive storage
  final storageService = HiveStorageService();
  await storageService.init();

  // Initialize audio manager
  final audioManager = AudioManager();
  await audioManager.init();

  runApp(
    ProviderScope(
      overrides: [
        audioManagerProvider.overrideWithValue(audioManager),
      ],
      child: const LearningApp(),
    ),
  );
}

/// Provider for AudioManager instance.
final audioManagerProvider = Provider<AudioManager>((ref) {
  throw UnimplementedError('AudioManager must be initialized before use');
});
