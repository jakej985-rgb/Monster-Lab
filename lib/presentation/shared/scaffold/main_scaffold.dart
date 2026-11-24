import 'dart:io' show Platform, exit;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
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

class MainScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  static const double desktopBreakpoint = 720.0;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  static const MethodChannel _windowChannel =
      MethodChannel('monster_lab/window');
  static const MethodChannel _menuChannel = MethodChannel('monster_lab/menu');
  static const List<LogicalKeyboardKey> _branchShortcutKeys = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
  ];

  StatefulNavigationShell get navigationShell => widget.navigationShell;

  bool _nativeMenuEnabled = false;

  @override
  void initState() {
    super.initState();
    _nativeMenuEnabled = ref.read(nativeMenuBarAvailableProvider);
    _menuChannel.setMethodCallHandler(_handleNativeMenuCommand);
    if (_nativeMenuEnabled) {
      _setNativeMenuVisible(true);
    }
  }

  @override
  void dispose() {
    if (_nativeMenuEnabled) {
      _setNativeMenuVisible(false);
    }
    _menuChannel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _setNativeMenuVisible(bool visible) async {
    try {
      await _menuChannel.invokeMethod<void>('setVisible', visible);
    } on MissingPluginException {
      // Widget tests and non-native runners do not expose the menu channel.
    } on PlatformException {
      // A missing native menu must not break startup or teardown.
    }
  }

  Future<void> _handleNativeMenuCommand(MethodCall call) async {
    if (call.method != 'menuCommand') return;
    final command = call.arguments;
    if (command is! String || !mounted) return;

    switch (command) {
      case 'preferences':
        context.push(RoutePaths.settings);
        break;
      case 'navigate-0':
        navigationShell.goBranch(0);
        break;
      case 'navigate-1':
        navigationShell.goBranch(1);
        break;
      case 'navigate-2':
        navigationShell.goBranch(2);
        break;
      case 'navigate-3':
        navigationShell.goBranch(3);
        break;
      case 'navigate-4':
        navigationShell.goBranch(4);
        break;
      case 'zoom-in':
        await ref.read(settingsNotifierProvider.notifier).zoomIn();
        break;
      case 'zoom-out':
        await ref.read(settingsNotifierProvider.notifier).zoomOut();
        break;
      case 'zoom-reset':
        await ref.read(settingsNotifierProvider.notifier).resetZoom();
        break;
      case 'about':
        GtkAboutDialog.show(context);
        break;
      case 'quit':
        await _handleQuit();
        break;
    }
  }

  Future<void> _handleQuit() async {
    if (!kIsWeb && Platform.isLinux) {
      try {
        await _windowChannel.invokeMethod<void>('closeWindow');
        return;
      } on MissingPluginException {
        // Older runners and widget tests do not expose the window channel.
      } on PlatformException {
        // Fall through so the user is never trapped without a quit path.
      }
    }

    if (!kIsWeb && (Platform.isWindows || Platform.isMacOS)) {
      exit(0);
    }

    SystemNavigator.pop();
  }

  void _showNotice(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 6)),
      );
    });
  }

  /// The shell breakpoint must follow the real window, not the scaled canvas.
  /// Otherwise a 125% UI zoom can make an 800px window render the mobile shell.
  double _windowWidth(BuildContext context) {
    // Depend on MediaQuery so a window resize rebuilds the shell. UiScaleCanvas
    // divides the MediaQuery size by the UI scale and multiplies its pixel
    // ratio, so this ratio recovers the unscaled window width.
    final mediaQuery = MediaQuery.of(context);
    final viewPixelRatio = View.of(context).devicePixelRatio;
    if (viewPixelRatio <= 0) {
      return mediaQuery.size.width;
    }
    return mediaQuery.size.width *
        (mediaQuery.devicePixelRatio / viewPixelRatio);
  }

  Map<ShortcutActivator, VoidCallback> _buildShortcuts(
    BuildContext context,
    WidgetRef ref,
    StatefulNavigationShell navigationShell,
  ) {
    return <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.comma, control: true): () =>
          context.push(RoutePaths.settings),
      const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () =>
          _handleQuit(),
      const SingleActivator(LogicalKeyboardKey.equal, control: true): () =>
          ref.read(settingsNotifierProvider.notifier).zoomIn(),
      const SingleActivator(LogicalKeyboardKey.minus, control: true): () =>
          ref.read(settingsNotifierProvider.notifier).zoomOut(),
      const SingleActivator(LogicalKeyboardKey.digit0, control: true): () =>
          ref.read(settingsNotifierProvider.notifier).resetZoom(),
      for (var index = 0; index < _branchShortcutKeys.length; index++)
        SingleActivator(_branchShortcutKeys[index], control: true): () =>
            navigationShell.goBranch(index),
      const SingleActivator(LogicalKeyboardKey.f1): () =>
          GtkAboutDialog.show(context),
    };
  }

  @override
  Widget build(BuildContext context) {
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

    final screenWidth = _windowWidth(context);
    final isDesktop = screenWidth >= MainScaffold.desktopBreakpoint;
    final useNativeMenuBar =
        isDesktop && ref.watch(nativeMenuBarAvailableProvider);
    final Widget shell;

    if (isDesktop) {
      final theme = Theme.of(context);
      final borderColor = theme.colorScheme.outlineVariant;

      shell = Scaffold(
        body: Column(
          children: [
            if (!useNativeMenuBar) ...[
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
                                onPressed: () => _handleQuit(),
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
                                shortcut: const SingleActivator(
                                    LogicalKeyboardKey.f1),
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
            ],

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
    } else {
      final colorScheme = Theme.of(context).colorScheme;
      shell = Scaffold(
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
              icon: Icon(Icons.home_outlined,
                  color: colorScheme.onSurfaceVariant),
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
              selectedIcon: Icon(Icons.precision_manufacturing,
                  color: colorScheme.primary),
              label: AppStrings.tabBuild,
            ),
            NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined,
                  color: colorScheme.onSurfaceVariant),
              selectedIcon:
                  Icon(Icons.emoji_events, color: colorScheme.primary),
              label: AppStrings.tabProgress,
            ),
          ],
        ),
      );
    }

    return CallbackShortcuts(
      bindings: _buildShortcuts(context, ref, navigationShell),
      child: Focus(autofocus: true, child: shell),
    );
  }
}
