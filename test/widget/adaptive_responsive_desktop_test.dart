import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/app.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/settings_datasource.dart';
import 'package:monster_lab/data/repositories/settings_repository_impl.dart';
import 'package:monster_lab/presentation/features/settings/settings_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:monster_lab/presentation/shared/scaffold/main_scaffold.dart';
import 'package:monster_lab/presentation/shared/widgets/desktop_status_bar.dart';
import 'package:monster_lab/presentation/shared/widgets/gtk_about_dialog.dart';
import 'package:monster_lab/presentation/shared/widgets/gtk_sidebar.dart';
import 'package:monster_lab/presentation/shared/widgets/responsive_content_container.dart';

void main() {
  group('Adaptive Responsive Desktop & Linux Layout Tests', () {
    testWidgets(
        'MainScaffold renders NavigationBar on mobile width (<720) and GtkSidebar, MenuBar, StatusBar on desktop (>=720)',
        (tester) async {
      final router = GoRouter(
        initialLocation: '/test1',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainScaffold(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/test1',
                  builder: (_, __) => const Text('Branch 1 Content'),
                ),
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/test2',
                  builder: (_, __) => const Text('Branch 2 Content'),
                ),
              ]),
            ],
          ),
        ],
      );

      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();

      // 1. Mobile screen (width: 400, height: 800)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(GtkSidebar), findsNothing);

      // 2. Desktop screen (width: 1280, height: 720)
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtkSidebar), findsOneWidget);
      expect(find.byType(MenuBar), findsOneWidget);
      expect(find.byType(DesktopStatusBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      // Global shortcuts must work while menus are closed.
      await tester.sendKeyEvent(LogicalKeyboardKey.f1);
      await tester.pumpAndSettle();
      expect(find.byType(GtkAboutDialog), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(find.text('Branch 2 Content'), findsOneWidget);
    });

    testWidgets(
        'MainScaffold uses native menu mode without rendering the Flutter MenuBar',
        (tester) async {
      final router = GoRouter(
        initialLocation: '/native-menu',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainScaffold(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/native-menu',
                  builder: (_, __) => const Text('Native menu content'),
                ),
              ]),
            ],
          ),
        ],
      );

      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();

      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
            nativeMenuBarAvailableProvider.overrideWithValue(true),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MenuBar), findsNothing);
      expect(find.byType(GtkSidebar), findsOneWidget);
      expect(find.text('Native menu content'), findsOneWidget);
    });

    testWidgets('UiScaleCanvas fills the viewport at 80% scale',
        (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: UiScaleCanvas(
            scale: 0.80,
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => tapped = true,
                child: const SizedBox(
                  width: 80,
                  height: 80,
                  child: ColoredBox(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The scaled canvas must reach the physical bottom-right corner.
      await tester.tapAt(const Offset(990, 790));
      expect(tapped, isTrue);
    });

    testWidgets(
        'ResponsiveContentContainer constrains maxWidth on wide screens',
        (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveContentContainer(
              maxWidth: 1040,
              child: SizedBox(
                width: double.infinity,
                height: 100,
                key: Key('inner_box'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final boxSize = tester.getSize(find.byKey(const Key('inner_box')));
      expect(boxSize.width, equals(1040));
    });

    testWidgets(
        'SettingsScreen renders UI scaling, theme presets, and launches GtkAboutDialog',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Display & UI Scaling'), findsOneWidget);
      expect(find.text('Auto (Recommended)'), findsOneWidget);
      expect(find.text('80% (Compact)'), findsOneWidget);

      // Select 80% (Compact)
      await tester.tap(find.text('80% (Compact)'));
      await tester.pumpAndSettle();

      final repo = SettingsRepositoryImpl(SettingsDataSource(storage));
      expect(repo.getSettings().uiScale, equals(0.80));

      // Drag until Linux Mint theme preset is visible and select it
      await tester.dragUntilVisible(
        find.text('Linux Mint (Mint-Y Green)'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Linux Mint (Mint-Y Green)'));
      await tester.pumpAndSettle();
      expect(repo.getSettings().themePreset, equals('mint'));

      // Drag until About Monster Lab card is visible and tap it
      await tester.dragUntilVisible(
        find.text('About Monster Lab'),
        find.byType(ListView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('About Monster Lab'));
      await tester.pumpAndSettle();

      expect(find.byType(GtkAboutDialog), findsOneWidget);
      expect(find.text('License: MIT (100% Offline)'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(GtkAboutDialog), findsNothing);
    });

    testWidgets('MainScaffold MenuBar includes View menu with Zoom controls',
        (tester) async {
      final router = GoRouter(
        initialLocation: '/test',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainScaffold(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/test',
                  builder: (_, __) => const Text('Content'),
                ),
              ]),
            ],
          ),
        ],
      );

      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();

      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('View'), findsOneWidget);
      expect(find.text('File'), findsOneWidget);
      expect(find.text('Navigate'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
    });

    testWidgets(
        'GtkSidebar rows are keyboard focusable, show tooltips and semantics, and activate via Enter/Space',
        (tester) async {
      int? selectedIndex;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF87A556)),
          ),
          home: Scaffold(
            body: GtkSidebar(
              selectedIndex: 0,
              onDestinationSelected: (idx) => selectedIndex = idx,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify FocusableActionDetector and Tooltip presence for all destinations and footer
      expect(find.byType(FocusableActionDetector), findsAtLeastNWidgets(6));
      expect(find.byType(Tooltip), findsAtLeastNWidgets(6));

      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;

      // Tab navigation into the first sidebar item ('Home')
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      // Tab again to focus the second item ('Learn', index 1)
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      // Verify that focused item has the theme primary color border outline
      final primaryColor =
          Theme.of(tester.element(find.byType(GtkSidebar))).colorScheme.primary;
      final containers =
          tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      final hasFocusBorder = containers.any((c) {
        final decoration = c.decoration as BoxDecoration?;
        final border = decoration?.border as Border?;
        return border?.top.color == primaryColor && border?.top.width == 1.5;
      });
      expect(hasFocusBorder, isTrue);

      // Activate with Enter key
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selectedIndex, equals(1));

      // Tab to the third item ('Parts Lab', index 2)
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      // Activate with Space key
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(selectedIndex, equals(2));
    });

    testWidgets(
        'DesktopStatusBar reports real hardware state and survives 200% text scaling',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();

      tester.view.physicalSize = const Size(800, 500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
          ],
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2.0),
              ),
              child: child!,
            ),
            home: const Scaffold(body: DesktopStatusBar()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hardware Offline'), findsOneWidget);
      expect(find.text('Hardware Ready'), findsNothing);
      expect(find.text('Auto (100%)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('125% UI zoom keeps desktop chrome on an 850px window',
        (tester) async {
      final router = GoRouter(
        initialLocation: '/zoom',
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainScaffold(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/zoom',
                  builder: (_, __) => const Text('Zoom Content'),
                ),
              ]),
            ],
          ),
        ],
      );

      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();

      tester.view.physicalSize = const Size(850, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storage),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            builder: (context, child) =>
                UiScaleCanvas(scale: 1.25, child: child!),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GtkSidebar), findsOneWidget);
      expect(find.byType(MenuBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });
  });
}
