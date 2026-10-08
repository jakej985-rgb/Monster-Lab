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
  group('Home Screen Next Lesson Progression Tests', () {
    late CurriculumDataEngine engine;

    setUp(() async {
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();
    });

    testWidgets('Initially renders Lesson 1 as START HERE', (tester) async {
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
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      final element = tester.element(find.byType(HomeScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(nextLessonProvider.future);
      await tester.pumpAndSettle();

      expect(find.text('START HERE'), findsOneWidget);
      expect(find.textContaining('What Is Arduino?'), findsOneWidget);
      expect(find.text('Start Lesson'), findsOneWidget);
    });

    testWidgets(
        'When Lesson 1 is completed, advances to next lesson as UP NEXT',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'monster_lab_active_profile_id': 'prof_1',
        'monster_lab_profiles':
            '[{"id":"prof_1","nickname":"Sparky","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
        'monster_lab_progress_prof_1':
            '{"learnerId":"prof_1","totalXp":100,"completedLessonIds":["lesson_01"],"completedProjectIds":[],"discoveredComponentIds":[],"solvedChallengeIds":[],"unlockedBadgeIds":[],"stepProgress":{},"lastSessionDate":"2026-01-01T00:00:00.000Z"}',
      });
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider
                .overrideWithValue(CurriculumRepositoryImpl(engine)),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      final element = tester.element(find.byType(HomeScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(nextLessonProvider.future);
      await tester.pumpAndSettle();

      expect(find.text('UP NEXT'), findsOneWidget);
      expect(find.textContaining('What Is Code?'), findsOneWidget);
      expect(find.text('Start Lesson'), findsOneWidget);
    });

    testWidgets(
        'When all sub-lessons l01_01..l01_12 and course lesson_01 are completed without legacy ID, advances to next lesson',
        (tester) async {
      final l01SubLessons = [
        for (int i = 1; i <= 12; i++) '"l01_${i.toString().padLeft(2, '0')}"'
      ];
      SharedPreferences.setMockInitialValues({
        'monster_lab_active_profile_id': 'prof_1',
        'monster_lab_profiles':
            '[{"id":"prof_1","nickname":"Sparky","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
        'monster_lab_progress_prof_1':
            '{"learnerId":"prof_1","totalXp":220,"completedLessonIds":[${l01SubLessons.join(',')}],"completedCourseIds":["lesson_01"],"completedProjectIds":[],"discoveredComponentIds":[],"solvedChallengeIds":[],"unlockedBadgeIds":[],"stepProgress":{},"lastSessionDate":"2026-01-01T00:00:00.000Z"}',
      });
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider
                .overrideWithValue(CurriculumRepositoryImpl(engine)),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      final element = tester.element(find.byType(HomeScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(nextLessonProvider.future);
      await tester.pumpAndSettle();

      expect(find.text('UP NEXT'), findsOneWidget);
      expect(find.textContaining('What Is Code?'), findsOneWidget);
      expect(find.text('Start Lesson'), findsOneWidget);
    });

    testWidgets('When all lessons are completed, displays celebration card',
        (tester) async {
      final allLessons = (await engine.getLessons()).map((l) => l.id).toList();
      final completedLessonsJson = '["${allLessons.join('","')}"]';

      SharedPreferences.setMockInitialValues({
        'monster_lab_active_profile_id': 'prof_1',
        'monster_lab_profiles':
            '[{"id":"prof_1","nickname":"Sparky","avatarId":"monster_spark","ageBracket":"ages10_12","createdAt":"2026-01-01T00:00:00.000Z","lastActiveAt":"2026-01-01T00:00:00.000Z","settings":{}}]',
        'monster_lab_progress_prof_1':
            '{"learnerId":"prof_1","totalXp":1500,"completedLessonIds":$completedLessonsJson,"completedProjectIds":[],"discoveredComponentIds":[],"solvedChallengeIds":[],"unlockedBadgeIds":[],"stepProgress":{},"lastSessionDate":"2026-01-01T00:00:00.000Z"}',
      });
      final storageService = await StorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider
                .overrideWithValue(CurriculumRepositoryImpl(engine)),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      final element = tester.element(find.byType(HomeScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(nextLessonProvider.future);
      await tester.pumpAndSettle();

      expect(find.text('CURRICULUM COMPLETE!'), findsOneWidget);
      expect(find.text('All Lessons Completed! 🏆'), findsOneWidget);
      expect(find.text('Explore Projects in Build Lab'), findsOneWidget);
    });
  });
}
