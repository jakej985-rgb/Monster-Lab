import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/app.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  late CurriculumDataEngine engine;

  setUp(() async {
    engine = CurriculumDataEngine();
    await engine.initialize();
  });

  testWidgets(
      'Monster Lab application boots and renders all 5 bottom navigation tabs',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'monster_lab_active_profile_id': 'prof_default',
      'monster_lab_profiles':
          '[{"id":"prof_default","nickname":"Tester","avatarId":"avatar_sparky","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
    });
    final storageService = await StorageService.init();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumDataEngineProvider.overrideWithValue(engine),
        ],
        child: const MonsterLabApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify all 5 navigation tabs are rendered
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Parts Lab'), findsOneWidget);
    expect(find.text('Build Lab'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);

    // Switch to Learn tab
    await tester.tap(find.text('Learn'));
    await tester.pumpAndSettle();
    expect(find.text('Learn Lab'), findsOneWidget);

    // Switch to Parts Lab tab
    await tester.tap(find.text('Parts Lab'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.extension), findsWidgets);

    // Switch to Build Lab tab
    await tester.tap(find.text('Build Lab'));
    await tester.pumpAndSettle();
    expect(find.text('Build Lab'), findsWidgets);

    // Switch to Progress tab
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    expect(find.text('Earned Badges'), findsOneWidget);
  });
}
