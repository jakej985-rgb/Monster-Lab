import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/app_strings.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'presentation/shared/widgets/gtk_about_dialog.dart';
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
      theme: AppTheme.buildTheme(
        isDark: false,
        preset: themePreset,
        highContrast: settings.highContrast,
      ),
      darkTheme: AppTheme.buildTheme(
        isDark: true,
        preset: themePreset,
        highContrast: settings.highContrast,
      ),
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        final double effectiveScale =
            settings.uiScale > 0.0 ? settings.uiScale : defaultUiScale();

        Widget appWidget = child;
        if (effectiveScale != 1.0) {
          appWidget = UiScaleCanvas(
            scale: effectiveScale,
            child: child,
          );
        }

        return CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.equal, control: true): () {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .zoomIn(baseScale: effectiveScale);
            },
            const SingleActivator(LogicalKeyboardKey.minus, control: true): () {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .zoomOut(baseScale: effectiveScale);
            },
            const SingleActivator(LogicalKeyboardKey.digit0, control: true):
                () {
              ref.read(settingsNotifierProvider.notifier).resetZoom();
            },
            const SingleActivator(LogicalKeyboardKey.f1): () {
              final navContext = rootNavigatorKey.currentContext;
              if (navContext != null) {
                GtkAboutDialog.show(navContext);
              }
            },
          },
          child: appWidget,
        );
      },
    );
  }
}

/// Scales the whole app canvas without leaving unused space around it.
class UiScaleCanvas extends StatelessWidget {
  final double scale;
  final Widget child;

  const UiScaleCanvas({
    super.key,
    required this.scale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : mediaQuery.size.width;
        final double height = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : mediaQuery.size.height;

        final double scaledWidth = width / scale;
        final double scaledHeight = height / scale;

        final scaledMediaQuery = mediaQuery.copyWith(
          size: Size(scaledWidth, scaledHeight),
          devicePixelRatio: mediaQuery.devicePixelRatio * scale,
          padding: mediaQuery.padding / scale,
          viewPadding: mediaQuery.viewPadding / scale,
          viewInsets: mediaQuery.viewInsets / scale,
        );

        return MediaQuery(
          data: scaledMediaQuery,
          child: FittedBox(
            fit: BoxFit.fill,
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
  }
}
