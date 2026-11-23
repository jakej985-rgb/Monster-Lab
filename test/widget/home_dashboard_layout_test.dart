import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/presentation/features/home/home_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:monster_lab/presentation/shared/scaffold/main_scaffold.dart';

void main() {
  testWidgets(
      'Home dashboard shows its side rail without page scrolling in the desktop shell',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final engine =
        CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
    await engine.initialize();
    SharedPreferences.setMockInitialValues({
      'monster_lab_active_profile_id': 'prof_1',
      'monster_lab_profiles':
          '[{"id":"prof_1","nickname":"Sparky","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
    });
    final storageService = await StorageService.init();

    // Use the real desktop shell so the menu bar, sidebar and status bar are
    // included in the available-height calculation.
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScaffold(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomeScreen(),
              ),
            ]),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    final element = tester.element(find.byType(HomeScreen));
    final container = ProviderScope.containerOf(element);
    await container.read(nextLessonProvider.future);
    await tester.pumpAndSettle();

    expect(find.byType(MainScaffold), findsOneWidget);
    expect(find.byKey(const Key('home_dashboard_side_rail')), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final scrollableFinder = find.descendant(
      of: find.byKey(const Key('home_dashboard_scroll')),
      matching: find.byType(Scrollable),
    );
    expect(scrollableFinder, findsOneWidget);
    final scrollable = tester.state<ScrollableState>(scrollableFinder);
    expect(scrollable.position.maxScrollExtent, 0.0);
  });
}
