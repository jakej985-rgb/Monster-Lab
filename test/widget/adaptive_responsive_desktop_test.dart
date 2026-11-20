import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/settings_datasource.dart';
import 'package:monster_lab/data/repositories/settings_repository_impl.dart';
import 'package:monster_lab/presentation/features/settings/settings_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:monster_lab/presentation/shared/scaffold/main_scaffold.dart';
import 'package:monster_lab/presentation/shared/widgets/responsive_content_container.dart';

void main() {
  group('Adaptive Responsive Desktop & Linux Layout Tests', () {
    testWidgets(
        'MainScaffold renders NavigationBar on mobile width (<720) and NavigationRail on desktop (>=720)',
        (tester) async {
      // Create a test StatefulNavigationShell mock
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

      // 1. Mobile screen (width: 400, height: 800)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);

      // 2. Desktop screen (width: 1280, height: 720)
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
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
        'SettingsScreen renders Display & UI Scaling selector and updates scale',
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
      expect(find.text('90% (Desktop Standard)'), findsOneWidget);
      expect(find.text('80% (Compact)'), findsOneWidget);

      // Select 90% (Desktop Standard)
      await tester.tap(find.text('90% (Desktop Standard)'));
      await tester.pumpAndSettle();

      // Check persisted in storage
      final repo = SettingsRepositoryImpl(SettingsDataSource(storage));
      expect(repo.getSettings().uiScale, equals(0.90));
    });
  });
}
