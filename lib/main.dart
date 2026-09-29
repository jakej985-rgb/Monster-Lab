import 'dart:async';
import 'package:flutter/material.dart';
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
        ],
        child: const MonsterLabApp(),
      ),
    );
  }, (error, stack) {
    AppLogger.error('Unhandled engine error caught in main zone', error, stack);
  });
}
