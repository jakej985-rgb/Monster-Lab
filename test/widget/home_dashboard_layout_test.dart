import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/presentation/features/home/home_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  testWidgets(
      'Home dashboard shows its side rail without scrolling at 1280x720',
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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pump();
    final element = tester.element(find.byType(HomeScreen));
    final container = ProviderScope.containerOf(element);
    await container.read(nextLessonProvider.future);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home_dashboard_side_rail')), findsOneWidget);
    expect(find.text('Achievements'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final scrollable =
        tester.state<ScrollableState>(find.byType(Scrollable).first);
    expect(scrollable.position.maxScrollExtent, 0.0);
  });
}
