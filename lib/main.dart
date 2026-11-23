import 'dart:async';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/logging/app_logger.dart';
import 'core/services/storage_service.dart';
import 'presentation/shared/providers.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.info('Initializing Monster Lab application engine...');

    final storageService = await StorageService.init();

    runApp(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          nativeMenuBarAvailableProvider.overrideWithValue(
            !kIsWeb && defaultTargetPlatform == TargetPlatform.linux,
          ),
        ],
        child: const MonsterLabApp(),
      ),
    );
  }, (error, stack) {
    AppLogger.error('Unhandled engine error caught in main zone', error, stack);
  });
}
