import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/app.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('End-to-End User Navigation & Routing Flow Tests', () {
    late CurriculumDataEngine engine;

    setUp(() async {
      engine = CurriculumDataEngine();
      await engine.initialize();
    });

    testWidgets('Full user navigation flow across all 5 tabs and sub-routes',
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

      // 1. Verify Home screen loads with navigation destinations
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('Parts Lab'), findsOneWidget);
      expect(find.text('Build Lab'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);

      // 2. Navigate to Learn Lab tab
      await tester.tap(find.text('Learn'));
      await tester.pumpAndSettle();
      expect(find.text('Learn Lab'), findsOneWidget);

      // 3. Navigate to Parts Lab tab
      await tester.tap(find.text('Parts Lab'));
      await tester.pumpAndSettle();
      expect(find.text('Parts Lab'), findsWidgets);
      expect(find.byType(TextField), findsOneWidget);

      // 4. Navigate to Build Lab tab
      await tester.tap(find.text('Build Lab'));
      await tester.pumpAndSettle();
      expect(find.text('Build Lab'), findsWidgets);

      // 5. Navigate to Progress tab
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();
      expect(find.text('Earned Badges'), findsOneWidget);

      // 6. Return to Home tab
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Tester'), findsWidgets);

      // 7. Tap avatar in AppBar to open Profile Select Screen
      final avatarFinder = find.bySemanticsLabel(RegExp(r'Switch profile'));
      expect(avatarFinder, findsOneWidget);
      await tester.tap(avatarFinder);
      await tester.pumpAndSettle();

      // Verify Profile Select Screen rendered
      expect(find.text('Learner Profiles'), findsOneWidget);
      expect(find.text('Who is learning today?'), findsOneWidget);
    });
  });
}
