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

  // Set system UI overlay style for night mode
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.nightBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive storage
  await HiveStorageService.initialize();

  // Initialize audio manager with night mode
  final audioManager = AudioManager();
  await audioManager.initialize();
  audioManager.setNightMode(true);

  runApp(
    ProviderScope(
      overrides: [
        audioManagerProvider.overrideWithValue(audioManager),
      ],
      child: const PictureBookApp(),
    ),
  );
}

/// Provider for AudioManager instance.
final audioManagerProvider = Provider<AudioManager>((ref) {
  throw UnimplementedError('AudioManager must be initialized before use');
});
