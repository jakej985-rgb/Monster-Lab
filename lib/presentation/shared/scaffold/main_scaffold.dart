import 'dart:io' show Platform, exit;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/routing/route_constants.dart';
import '../../../data/datasources/curriculum_data_engine.dart';
import '../providers.dart';
import '../widgets/desktop_status_bar.dart';
import '../widgets/gtk_about_dialog.dart';
import '../widgets/gtk_sidebar.dart';

class MainScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  static const double desktopBreakpoint = 720.0;

  void _handleQuit() {
    if (!kIsWeb &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  void _showNotice(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 6)),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String>>(progressCorruptionProvider,
        (previous, next) {
      final message = next.value;
      if (message != null && previous?.value != message) {
        _showNotice(context, message);
      }
    });
    ref.listen<AsyncValue<CurriculumEngineStatus>>(
      curriculumHealthProvider,
      (previous, next) {
        if (next.hasError && previous?.hasError != true) {
          _showNotice(
            context,
            'Curriculum assets could not be initialized: ${next.error}',
          );
        } else if (next.value == CurriculumEngineStatus.fallbackActive &&
            previous?.value != CurriculumEngineStatus.fallbackActive) {
          _showNotice(
            context,
            'Curriculum assets failed validation; Monster Lab is using the bundled offline baseline.',
          );
        }
      },
    );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= desktopBreakpoint;

    if (isDesktop) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final borderColor =
          isDark ? const Color(0xFF3C4049) : const Color(0xFFDCDCDC);

      return Scaffold(
        body: Column(
          children: [
            // Desktop Top MenuBar (File, Navigate, Help)
            Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MenuBar(
                      children: [
                        SubmenuButton(
                          menuChildren: [
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.comma,
                                  control: true),
                              onPressed: () =>
                                  context.push(RoutePaths.settings),
                              child: const Text('Preferences...'),
                            ),
                            const Divider(),
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.keyQ,
                                  control: true),
                              onPressed: _handleQuit,
                              child: const Text('Quit Monster Lab'),
                            ),
                          ],
                          child: const Text('File'),
                        ),
                        SubmenuButton(
                          menuChildren: [
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.digit1,
                                  control: true),
                              onPressed: () => navigationShell.goBranch(0),
                              child: const Text('Home'),
                            ),
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.digit2,
                                  control: true),
                              onPressed: () => navigationShell.goBranch(1),
                              child: const Text('Learn'),
                            ),
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.digit3,
                                  control: true),
                              onPressed: () => navigationShell.goBranch(2),
                              child: const Text('Parts Lab'),
                            ),
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.digit4,
                                  control: true),
                              onPressed: () => navigationShell.goBranch(3),
                              child: const Text('Build Studio'),
                            ),
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.digit5,
                                  control: true),
                              onPressed: () => navigationShell.goBranch(4),
                              child: const Text('Progress & Badges'),
                            ),
                          ],
                          child: const Text('Navigate'),
                        ),
                        SubmenuButton(
                          menuChildren: [
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.equal,
                                  control: true),
                              onPressed: () => ref
                                  .read(settingsNotifierProvider.notifier)
                                  .zoomIn(),
                              child: const Text('Zoom In'),
                            ),
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.minus,
                                  control: true),
                              onPressed: () => ref
                                  .read(settingsNotifierProvider.notifier)
                                  .zoomOut(),
                              child: const Text('Zoom Out'),
                            ),
                            const Divider(),
                            MenuItemButton(
                              shortcut: const SingleActivator(
                                  LogicalKeyboardKey.digit0,
                                  control: true),
                              onPressed: () => ref
                                  .read(settingsNotifierProvider.notifier)
                                  .resetZoom(),
                              child: const Text('Normal Size (Reset)'),
                            ),
                          ],
                          child: const Text('View'),
                        ),
                        SubmenuButton(
                          menuChildren: [
                            MenuItemButton(
                              shortcut:
                                  const SingleActivator(LogicalKeyboardKey.f1),
                              onPressed: () => GtkAboutDialog.show(context),
                              child: const Text('About Monster Lab'),
                            ),
                          ],
                          child: const Text('Help'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Middle: GTK Sidebar + Active Screen Shell
            Expanded(
              child: Row(
                children: [
                  GtkSidebar(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      );
                    },
                  ),
                  Expanded(child: navigationShell),
                ],
              ),
            ),

            // Bottom: Desktop Status Bar
            const DesktopStatusBar(),
          ],
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon:
                Icon(Icons.home_outlined, color: colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.home, color: colorScheme.primary),
            label: AppStrings.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.school, color: colorScheme.primary),
            label: AppStrings.tabLearn,
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.extension, color: colorScheme.primary),
            label: AppStrings.tabParts,
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.precision_manufacturing, color: colorScheme.primary),
            label: AppStrings.tabBuild,
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.emoji_events, color: colorScheme.primary),
            label: AppStrings.tabProgress,
          ),
        ],
      ),
    );
  }
}
