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
    final themePreset = settings.themePreset;
    final ThemeMode themeMode;
    switch (settings.themeMode) {
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'system':
      default:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(isDark: false, preset: themePreset),
      darkTheme: AppTheme.buildTheme(isDark: true, preset: themePreset),
      themeMode: themeMode,
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
          effectiveScale = isDesktop ? 0.80 : 1.0;
        }

        if (effectiveScale == 1.0) {
          return child;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.hasBoundedWidth
                ? constraints.maxWidth
                : mediaQuery.size.width;
            final double height = constraints.hasBoundedHeight
                ? constraints.maxHeight
                : mediaQuery.size.height;

            final double scaledWidth = width / effectiveScale;
            final double scaledHeight = height / effectiveScale;

            final scaledMediaQuery = mediaQuery.copyWith(
              size: Size(scaledWidth, scaledHeight),
              devicePixelRatio: mediaQuery.devicePixelRatio * effectiveScale,
              padding: mediaQuery.padding / effectiveScale,
              viewPadding: mediaQuery.viewPadding / effectiveScale,
              viewInsets: mediaQuery.viewInsets / effectiveScale,
            );

            return MediaQuery(
              data: scaledMediaQuery,
              child: Transform.scale(
                scale: effectiveScale,
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: scaledWidth,
                  height: scaledHeight,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
