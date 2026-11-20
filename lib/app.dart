import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/shared/providers.dart';

class MonsterLabApp extends ConsumerWidget {
  const MonsterLabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final mediaQuery = MediaQuery.of(context);

        final double effectiveScale;
        if (settings.uiScale > 0.0) {
          effectiveScale = settings.uiScale;
        } else {
          final isDesktop = !kIsWeb &&
              (Platform.isLinux || Platform.isWindows || Platform.isMacOS);
          effectiveScale = isDesktop ? 0.88 : 1.0;
        }

        final baseScale = mediaQuery.textScaler.scale(1.0);
        final adjustedTextScaler =
            TextScaler.linear(baseScale * effectiveScale);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: adjustedTextScaler,
          ),
          child: child,
        );
      },
    );
  }
}
