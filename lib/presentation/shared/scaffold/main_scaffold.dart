import 'dart:io' show Platform, exit;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primaryViolet.withValues(alpha: 0.15),
        elevation: 8,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryViolet),
            label: AppStrings.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: AppColors.primaryViolet),
            label: AppStrings.tabLearn,
          ),
          NavigationDestination(
            icon: Icon(Icons.extension_outlined),
            selectedIcon: Icon(Icons.extension, color: AppColors.primaryViolet),
            label: AppStrings.tabParts,
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined),
            selectedIcon: Icon(Icons.precision_manufacturing,
                color: AppColors.primaryViolet),
            label: AppStrings.tabBuild,
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon:
                Icon(Icons.emoji_events, color: AppColors.primaryViolet),
            label: AppStrings.tabProgress,
          ),
        ],
      ),
    );
  }
}
